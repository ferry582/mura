//
//  ViewController.swift
//  Mura
//
//  Created by Ferry Dwianta P on 29/06/23.
//

import UIKit
import MonthYearWheelPicker

class DashboardViewController: UIViewController {
    
    // MARK: - Variables
    private let reportViewModel: ReportViewModel
    private var transactionSections: [TransactionSection] = [
        TransactionSection(sectionTitle: "01", transactions: TransactionEntity.transactionData1),
        TransactionSection(sectionTitle: "30", transactions: TransactionEntity.transactionData2),
        TransactionSection(sectionTitle: "29", transactions: TransactionEntity.transactionData2),
    ]
    private var datePickerBottomConstraint: NSLayoutConstraint?
    
    // MARK: Life Cycle
    init(_ reportViewModel: ReportViewModel = ReportViewModel()) {
        self.reportViewModel = reportViewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupView()
        
        self.dashboardTableView.delegate = self
        self.dashboardTableView.dataSource = self
        
        dashboardTableViewHeader.didTapDateButton = {
            self.monthYearDatePicker.isHidden = false
            self.toolbar.isHidden = false
            self.animateDatePicker(to: 0)
        }
        
        dashboardTableViewHeader.balancePercentText = reportViewModel.getBalancePercentText()
    }
    
    // MARK: - UI Components
    private let dashboardTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .none
        table.register(TransactionSectionHeader.self, forHeaderFooterViewReuseIdentifier: TransactionSectionHeader.identifier)
        table.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.identifier)
        table.sectionHeaderTopPadding = 0
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let dashboardTableViewHeader: DashboardHeaderView = {
        let view = DashboardHeaderView()
//        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let monthYearDatePicker: MonthYearWheelPicker = {
        let picker = MonthYearWheelPicker()
        var dateComponents = DateComponents()
        let userCalendar = Calendar(identifier: .gregorian)
        picker.backgroundColor = UIColor.cardBg
        picker.isHidden = true
        dateComponents.year = 2015
        dateComponents.month = 1
        picker.minimumDate = userCalendar.date(from: dateComponents)! // Value of minDate should be the oldest transaction on db
        dateComponents.year = 1
        picker.maximumDate = Calendar.current.date(byAdding: dateComponents, to: Date())!
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let toolbar: UIToolbar = {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.isHidden = true
        toolbar.tintColor = UIColor.main
        toolbar.barTintColor = UIColor.cardBg
        toolbar.isTranslucent = false
        toolbar.setItems([cancelButton, flexSpace, doneButton], animated: true)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    // MARK: - UI Setup
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.textMain]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.textMain]
        
        navigationItem.title = "Dashboard"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.main
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.mainBg
        
        dashboardTableViewHeader.frame = CGRect(x: 0, y: 0, width: dashboardTableView.frame.size.width, height: 305) // Height still hardcoded, because there is a bug when using constraint (there is extra space between header and cells)
        dashboardTableView.tableHeaderView = dashboardTableViewHeader
//        dashboardTableView.tableHeaderView?.layoutIfNeeded()
        
        view.addSubview(dashboardTableView)
        view.addSubview(monthYearDatePicker)
        view.addSubview(toolbar)
        
        datePickerBottomConstraint = monthYearDatePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: monthYearDatePicker.frame.height)
        
        NSLayoutConstraint.activate([
            dashboardTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dashboardTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dashboardTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dashboardTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
//            dashboardTableViewHeader.widthAnchor.constraint(equalTo: dashboardTableView.widthAnchor),
            
            monthYearDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            monthYearDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            datePickerBottomConstraint!,
            
            toolbar.bottomAnchor.constraint(equalTo: monthYearDatePicker.topAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
    }
    
    // MARK: - Setup Action
    @objc private func addTapped() {
        print("add button tapped")
    }
    
    @objc func doneButtonTapped() {
        dashboardTableViewHeader.monthYearText = monthYearDatePicker.date.convertToMonthYearString()
        animateDatePicker(to: self.monthYearDatePicker.frame.height) { _ in
            self.monthYearDatePicker.isHidden = true
            self.toolbar.isHidden = true
        }
    }
    
    @objc func cancelButtonTapped() {
        animateDatePicker(to: self.monthYearDatePicker.frame.height) { _ in
            self.monthYearDatePicker.isHidden = true
            self.toolbar.isHidden = true
        }
    }
    
    private func animateDatePicker(to constant: CGFloat, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.datePickerBottomConstraint?.constant = constant
            self.view.layoutIfNeeded()
        }, completion: completion)
    }
    
    func didTapDateButton(){
        monthYearDatePicker.isHidden = false
        toolbar.isHidden = false
        animateDatePicker(to: 0)
    }
    
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: SECTION HEADER CELL
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.transactionSections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TransactionSectionHeader.identifier) as? TransactionSectionHeader else {
            fatalError("Failed to create transaction header cell")
        }
        let headerTitle = self.transactionSections[section].sectionTitle
        header.configure(with: headerTitle)
        return header
    }
    
    // MARK: CELLS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactionSections[section].transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.identifier, for: indexPath) as? TransactionCell
        cell?.configure(with: self.transactionSections[indexPath.section].transactions[indexPath.row])
        
        let isLastCell = tableView.numberOfRows(inSection: indexPath.section)-1 == indexPath.row
        if isLastCell {
            cell?.setupLastCell()
        }
        
        return cell ?? UITableViewCell()
    }
    
    // MARK: SECTION FOOTER CELL
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        15 // Give spacing 15 between section
    }
}
