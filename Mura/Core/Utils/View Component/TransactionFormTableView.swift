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

struct Section {
    let cells: [TransactionFormCell]
}

class NoCursorTextField: UITextField {
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
}

class TransactionFormCell: UITableViewCell {
    
    // MARK: - Variables
    var didSelect: (() -> Void)?
    
    // MARK: - UI Components
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.cardBg
        self.setupSeparatorView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    func setupSeparatorView() {
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
    
    func setupSingleRow() {
        self.layer.cornerRadius = 10
        separatorView.isHidden = true
    }
    
    func setupFirstRow(){
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        // Note: Kalau pakai contentView.layer.cornerRadius = 10, maka dibelakangnya masih ada view cell default yang mana corner radius-nya tidak ikut berubah
    }
    
    func setupLastRow(){
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        separatorView.isHidden = true
    }
}

class TransactionFormTableView: UITableView {
    
    // MARK: - Variables
    let formType: TransactionFormType
    var sections: [Section] = []
    
    let categories = ["Category 1", "Category 2", "Category 3"]
    var selectedCategory: String?
    
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
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return picker
    }()
    
    private let toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.tintColor = UIColor.main
        toolbar.barTintColor = UIColor.cardBg
        toolbar.isTranslucent = false
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        return toolbar
    }()
    
    private lazy var amountTextField: UITextField = {
        let textfield = UITextField()
        textfield.delegate = self
        textfield.placeholder = "0.00"
        textfield.textAlignment = .right
        textfield.keyboardType = .decimalPad
        textfield.textColor = .lightGray
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }() // note: kyknya lazy var ngebikin ada delay saat click textfieldnya diawal
    
    private lazy var categoryTextField: NoCursorTextField = {
        let textfield = NoCursorTextField()
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 11, height: 14))
        let imageView = UIImageView(image: UIImage(systemName: "chevron.up.chevron.down"))
        imageView.frame = CGRect(x: 3, y: 0, width: 11, height: 14)
        container.addSubview(imageView)
        textfield.rightView = container
        textfield.delegate = self
        textfield.text = "None"
        textfield.textAlignment = .right
        textfield.inputView = categoryPickerView
        textfield.inputAccessoryView = toolbar
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
    
    @objc func doneButtonTapped() {
        categoryTextField.resignFirstResponder()
    }
    
    @objc private func typeSegmentedChanged() {
        switch typeSegmentedControl.selectedSegmentIndex {
        case 0:
            print("New Option 1 selected")
        case 1:
            print("New Option 2 selected")
        default:
            break
        }
    }
    
    @objc func dateChanged(_ datePicker: UIDatePicker) {
        //        selectedDate = datePicker.date
        print(datePicker.date)
    }
    
    // make public function untuk dipanggil dari controller, sekalian aja dibikin checker apakah textfield nya kosong atau ngga. terus nanti berarti return nya TransactionEntity aja, kalau form nya udah keisi semua
    func getTransactionFormData() -> TransactionEntity {
        return TransactionEntity(date: Date(), category: "", note: "", amount: 0, type: .expense)
    }
}

extension TransactionFormTableView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "0123456789.,")
        let characterSet = CharacterSet(charactersIn: string)
        // Check if the entered characters are valid (numbers and at most one decimal point)
        let isOnlyNumber = allowedCharacters.isSuperset(of: characterSet) &&
        (string.range(of: ".") == nil || textField.text?.contains(".") == false) &&
        (string.range(of: ",") == nil || textField.text?.contains(",") == false)
        
        return if textField == categoryTextField {
            false // Disable direct text input by returning false
        } else if textField == amountTextField {
            isOnlyNumber // Only allow numeric value for amount textfield
        } else {
            true
        }
    }
}

extension TransactionFormTableView: UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categories[row]
        categoryTextField.text = selectedCategory
        //        categoryTextField.placeholder = selectedCategory
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
