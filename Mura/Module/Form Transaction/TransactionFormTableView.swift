//
//  FormTableView.swift
//  Mura
//
//  Created by Ferry Dwianta P on 08/10/23.
//

import UIKit

enum TransactionFormType {
    case add
    case edit
}

fileprivate struct Section {
    let cells: [TransactionFormCell]
}

class NoCursorTextField: UITextField {
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
}

class TransactionFormTableView: UITableView {
    
    // MARK: - Variables
    let formType: TransactionFormType
    fileprivate var sections: [Section] = []
    private var selectedType: TransactionType = .expense
    private var selectedCategory: Category = .emptyCategory
    
    // MARK: UI Components
    private let typeSegmentedControl: UISegmentedControl = {
        let segmented = UISegmentedControl(items: [TransactionType.expense.rawValue, TransactionType.income.rawValue])
        segmented.selectedSegmentIndex = 0
        segmented.addTarget(self, action: #selector(typeSegmentedChanged), for: .valueChanged)
        segmented.translatesAutoresizingMaskIntoConstraints = false
        return segmented
    }()
    
    private let noteTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Notes"
        textfield.textColor = .lightGray
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.tintColor = UIColor.main
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var amountTextField: UITextField = {
        let textfield = UITextField()
        let decimalSeparator = NSLocale.current.decimalSeparator!
        textfield.delegate = self
        textfield.placeholder = "0\(decimalSeparator)00"
        textfield.textAlignment = .right
        textfield.keyboardType = .decimalPad
        textfield.textColor = .lightGray
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }() // note: kyknya lazy var ngebikin ada delay saat click textfieldnya diawal
    
    private lazy var categoryToolbar: AccessoryToolbar = {
        let toolbar = AccessoryToolbar()
        toolbar.doneAction = {
            self.categoryTextField.resignFirstResponder()
        }
        return toolbar
    }()
    
    private lazy var categoryTextField: NoCursorTextField = {
        let textfield = NoCursorTextField()
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 11, height: 14))
        let imageView = UIImageView(image: UIImage(systemName: "chevron.up.chevron.down"))
        imageView.frame = CGRect(x: 3, y: 0, width: 11, height: 14)
        container.addSubview(imageView)
        textfield.rightView = container
        textfield.delegate = self
        textfield.text = Category.emptyCategory.name
        textfield.textAlignment = .right
        textfield.inputView = categoryPickerView
        textfield.inputAccessoryView = categoryToolbar
        textfield.tintColor = UIColor.lightGray
        textfield.textColor = UIColor.lightGray
        textfield.rightViewMode = .always
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var categoryPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = UIColor.cardBg
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    // MARK: Life Cycle
    init(formType: TransactionFormType) {
        self.formType = formType
        super.init(frame: .zero, style: .grouped)
        
        self.separatorStyle = .none
        
        self.delegate = self
        self.dataSource = self
        
        self.buildSections()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    func buildSections() {
        // Build Transaction type cell
        let typeCell = TransactionFormCell(style: .value1, reuseIdentifier: nil)
        typeCell.textLabel?.text = "Type"
        typeCell.contentView.addSubview(typeSegmentedControl)
        typeCell.contentView.addConstraints([
            typeSegmentedControl.centerYAnchor.constraint(equalTo: typeCell.contentView.centerYAnchor),
            typeSegmentedControl.trailingAnchor.constraint(equalTo: typeCell.contentView.trailingAnchor, constant: -16)
        ])
        
        // Build Transaction Amount Cell
        let amountCell = TransactionFormCell(style: .value1, reuseIdentifier: nil)
        amountCell.textLabel?.text = "Amount"
        amountCell.contentView.addSubview(amountTextField)
        amountCell.contentView.addConstraints([
            amountTextField.centerYAnchor.constraint(equalTo: amountCell.contentView.centerYAnchor),
            amountTextField.leadingAnchor.constraint(equalTo: amountCell.textLabel!.trailingAnchor, constant: 20),
            amountTextField.trailingAnchor.constraint(equalTo: amountCell.contentView.trailingAnchor, constant: -16)
        ])
        amountCell.didSelect = { [weak self] in
            self?.amountTextField.becomeFirstResponder()
        }
        
        // Build Transaction Category Cell
        let categoryCell = TransactionFormCell(style: .value1, reuseIdentifier: nil)
        categoryCell.textLabel?.text = "Category"
        categoryCell.contentView.addSubview(categoryTextField)
        categoryCell.contentView.addConstraints([
            categoryTextField.centerYAnchor.constraint(equalTo: categoryCell.contentView.centerYAnchor),
            categoryTextField.leadingAnchor.constraint(equalTo: categoryCell.textLabel!.trailingAnchor, constant: 20),
            categoryTextField.trailingAnchor.constraint(equalTo: categoryCell.contentView.trailingAnchor, constant: -19)
        ])
        categoryCell.didSelect = { [weak self] in
            self?.categoryTextField.becomeFirstResponder()
        }
        
        // Build Transaction Date Cell
        let dateCell = TransactionFormCell(style: .value1, reuseIdentifier: nil)
        dateCell.textLabel?.text = "Date"
        dateCell.contentView.addSubview(datePicker)
        dateCell.contentView.addConstraints([
            datePicker.centerYAnchor.constraint(equalTo: dateCell.contentView.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: dateCell.contentView.trailingAnchor, constant: -16)
        ])
        
        // Build Transaction Note Cell
        let noteCell = TransactionFormCell(style: .value1, reuseIdentifier: nil)
        noteCell.contentView.addSubview(noteTextField)
        noteCell.contentView.addConstraints([
            noteTextField.centerYAnchor.constraint(equalTo: noteCell.contentView.centerYAnchor),
            noteTextField.trailingAnchor.constraint(equalTo: noteCell.contentView.layoutMarginsGuide.trailingAnchor),
            noteTextField.leadingAnchor.constraint(equalTo: noteCell.contentView.leadingAnchor, constant: 16)
        ])
        noteCell.didSelect = { [weak self] in
            self?.noteTextField.becomeFirstResponder()
        }
        
        sections = [
            Section(cells: [typeCell]),
            Section(cells: [amountCell, categoryCell, dateCell]),
            Section(cells: [noteCell])
        ]
    }
    
    // MARK: Actions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.endEditing(true) // Handle keyboard dismissal when the user taps outside the UITextField
    }
    
    @objc private func typeSegmentedChanged() {
        switch typeSegmentedControl.selectedSegmentIndex {
        case 0:
            self.selectedType = .expense
            self.categoryTextField.text = Category.emptyCategory.name
            self.selectedCategory = Category.emptyCategory
            categoryTextField.resignFirstResponder()
            categoryPickerView.selectRow(0, inComponent: 0, animated: true)
        case 1:
            self.selectedType = .income
            self.categoryTextField.text = Category.emptyCategory.name
            self.selectedCategory = Category.emptyCategory
            categoryTextField.resignFirstResponder()
            categoryPickerView.selectRow(0, inComponent: 0, animated: true)
        default:
            break
        }
    }
    
    // MARK: Getter & Setter
    func getFormData() -> Transaction {
        return Transaction(
            id: UUID(),
            date: datePicker.date,
            category: selectedCategory,
            note: noteTextField.text,
            amount: convertToDecimalSeparator(amountText: amountTextField.text!),
            type: selectedType)
    }
    
    func setFormData(transaction: Transaction) {
        noteTextField.text = transaction.note
    }
    
    func convertToDecimalSeparator(amountText: String) -> Double {
        let dotSeparator = "."
        let decimalSeparator = NSLocale.current.decimalSeparator ?? dotSeparator
        let checkedAmount = if decimalSeparator != dotSeparator {
            amountText.replacingOccurrences(of: decimalSeparator, with: dotSeparator)
        } else {
            amountText
        }
        return Double(checkedAmount) ?? 0
    }
    
}

extension TransactionFormTableView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == amountTextField {
            guard let text = textField.text, let decimalSeparator = NSLocale.current.decimalSeparator else {
                return true
            }
            
            var splitText = text.components(separatedBy: decimalSeparator)
            let totalDecimalSeparators = splitText.count - 1
            let isEditingEnd = (text.count - 3) < range.lowerBound
            
            splitText.removeFirst()
            
            // Check if exceed 2 decimal point
            if splitText.last?.count ?? 0 > 1 && string.count != 0 && isEditingEnd {
                return false
            }
            
            // Allow only single dot
            if totalDecimalSeparators > 0 && string == decimalSeparator {
                return false
            }
            
            // Only allow numbers and decimal separator
            let allowedCharacters = CharacterSet(charactersIn: "0123456789\(decimalSeparator)")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        } else if textField == categoryTextField {
            return false
        } else {
            return true
        }
    }
}

extension TransactionFormTableView: UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectedType == .expense ? Category.expenseCategories.count : Category.incomeCategories.count
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selectedType == .expense ? Category.expenseCategories[row].name : Category.incomeCategories[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectedType == .expense {
            categoryTextField.text = Category.expenseCategories[row].name
            selectedCategory = .expenseCategories[row]
        } else {
            categoryTextField.text = Category.incomeCategories[row].name
            selectedCategory = .incomeCategories[row]
        }
    }
}

extension TransactionFormTableView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    func cell(for indexPath: IndexPath) -> TransactionFormCell {
        let cell = sections[indexPath.section].cells[indexPath.row]
        let totalRows = numberOfRows(inSection: indexPath.section)
        
        if totalRows == 1 {
            cell.setupSingleRow()
        } else if indexPath.row == 0{
            cell.setupFirstRow()
        } else if totalRows - 1 == indexPath.row {
            cell.setupLastRow()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell(for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cell(for: indexPath).didSelect?()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
