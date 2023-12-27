//
//  ViewController.swift
//  Mura
//
//  Created by Ferry Dwianta P on 29/06/23.
//

import UIKit
import MonthYearWheelPicker
import RxSwift

class DashboardViewController: UIViewController {
    
    // MARK: - Variables
    private let viewModel: DashboardViewModel
    private let reportViewModel: ReportViewModel
    private let disposeBag = DisposeBag()
    private var datePickerBottomConstraint: NSLayoutConstraint?
    private var transactionSections: [TransactionSection] = [] {
        didSet {
            dashboardTableView.reloadData()
        }
    }
    private var selectedMonthYear = Date()
    
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
        picker.minimumDate = userCalendar.date(from: dateComponents)!
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
    
    // MARK: Life Cycle
    init(viewModel: DashboardViewModel, reportViewModel: ReportViewModel = ReportViewModel()) {
        self.viewModel = viewModel
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
        
        self.selectedMonthYear = monthYearDatePicker.date
        
        dashboardTableViewHeader.didTapDateButton = {
            self.monthYearDatePicker.isHidden = false
            self.toolbar.isHidden = false
            self.animateDatePicker(to: 0)
        }
        
        Task {
            await viewModel.getTransactions(in: selectedMonthYear)
        }
        
        observeDataChanges()
        
        dashboardTableViewHeader.balancePercentText = reportViewModel.getBalancePercentText()
    }
    
    // MARK: - Observer
    private func observeDataChanges() {
        viewModel.transactionSections
            .observe(on: MainScheduler.instance)
            .subscribe (onNext: { [weak self] transactionSections in
                self?.transactionSections = transactionSections
            })
            .disposed(by: disposeBag)
        
        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { error in
                if let error = error {
                    if error is ValidationError {
                        print((error as! ValidationError).message)
                    } else {
                        print(error.localizedDescription)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                if isLoading {
                    print("loading...")
                } else {
                    print("stop loading")
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Setup
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.textMain]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.textMain]
        
        navigationItem.title = "Dashboard"
        navigationItem.titleView?.tintColor = UIColor.textMain
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
        let vc = AddTransactionViewController(viewModel: AddTransactionViewModel())
        vc.delegate = self
        let navigationController = UINavigationController(rootViewController: vc)
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.large()]
        }
        present(navigationController, animated: true)
    }
    
    @objc private func doneButtonTapped() {
        selectedMonthYear = monthYearDatePicker.date
        dashboardTableViewHeader.monthYearText = selectedMonthYear.convertToMonthYearString()
        
        Task {
            await viewModel.getTransactions(in: selectedMonthYear)
        }
        
        animateDatePicker(to: self.monthYearDatePicker.frame.height) { _ in
            self.monthYearDatePicker.isHidden = true
            self.toolbar.isHidden = true
        }
    }
    
    @objc private func cancelButtonTapped() {
        monthYearDatePicker.date = selectedMonthYear
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
    
    // MARK: - Callbacks
    func didTapDateButton(){
        monthYearDatePicker.isHidden = false
        toolbar.isHidden = false
        animateDatePicker(to: 0)
    }
    
}

extension DashboardViewController: AddTransactionViewControllerDelegate {
    func didTransactionCreated() {
        Task {
            await viewModel.getTransactions(in: selectedMonthYear)
        }
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
        let date = self.transactionSections[section].date
        let totalAmount = self.transactionSections[section].totalAmount
        header.configure(date: date, totalAmount: totalAmount)
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
