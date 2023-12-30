//
//  ViewController.swift
//  Mura
//
//  Created by Ferry Dwianta P on 29/06/23.
//

import UIKit
import MonthYearWheelPicker
import RxSwift
import RxDataSources

class DashboardViewController: UIViewController {
    
    // MARK: - Variables
    private let viewModel: DashboardViewModel
    private let reportViewModel: ReportViewModel
    private let disposeBag = DisposeBag()
    private var datePickerBottomConstraint: NSLayoutConstraint?
    private var selectedMonthYear = Date()
    private let dataSource = DashboardViewController.dataSource()
    
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
    
    private lazy var dashboardTableViewHeader: DashboardHeaderView = {
        let view = DashboardHeaderView()
        view.didTapDateButton = {
            self.monthYearDatePicker.isHidden = false
            self.toolbar.isHidden = false
            self.animateDatePicker(to: 0)
        }
//        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var monthYearDatePicker: MonthYearWheelPicker = {
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
    
    private lazy var toolbar: AccessoryToolbar = {
        let toolbar = AccessoryToolbar()
        toolbar.hasCancelButton()
        toolbar.isHidden = true
        toolbar.cancelAction = { [self] in
            monthYearDatePicker.date = selectedMonthYear
            animateDatePicker(to: monthYearDatePicker.frame.height) { _ in
                self.monthYearDatePicker.isHidden = true
                self.toolbar.isHidden = true
            }
        }
        toolbar.doneAction = { [self] in
            selectedMonthYear = monthYearDatePicker.date
            dashboardTableViewHeader.monthYearText = selectedMonthYear.convertToMonthYearString()

            Task { await viewModel.getTransactions(in: selectedMonthYear) }
            
            animateDatePicker(to: monthYearDatePicker.frame.height) { _ in
                self.monthYearDatePicker.isHidden = true
                self.toolbar.isHidden = true
            }
        }
        
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
        
        self.selectedMonthYear = monthYearDatePicker.date
        
        Task { await viewModel.getTransactions(in: selectedMonthYear) }
        
        observeDataChanges()
        
        dashboardTableViewHeader.balancePercentText = reportViewModel.getBalancePercentText()
        
        configureSectionModel()
    }
    
    // MARK: - Observer
    private func observeDataChanges() {
        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { error in
                if error is ValidationError {
                    print((error as! ValidationError).message)
                } else {
                    print(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                if isLoading {
                    print("[d] loading...")
                } else {
                    print("[d] stop loading")
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Setup
    private func configureSectionModel() {
        viewModel.transactionSections
            .filter({ [weak self] section in
                DispatchQueue.main.async { self?.dashboardTableView.reloadData() }
                if section.isEmpty {
                    print("[d] section data empty")
                } else {
                    print("[d] section data exist: \(section.count)")
                }
                return true
            })
            .bind(to: dashboardTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        dashboardTableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        dashboardTableView.rx.modelSelected(Transaction.self)
            .asDriver()
            .drive(onNext: { [weak self] transaction in
                print("[d] transaction id: \(transaction.id), with amount: \(transaction.amount)")
            })
            .disposed(by: disposeBag)
    }
    
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
    
    private func animateDatePicker(to constant: CGFloat, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.datePickerBottomConstraint?.constant = constant
            self.view.layoutIfNeeded()
        }, completion: completion)
    }
}

extension DashboardViewController {
    static func dataSource() -> RxTableViewSectionedReloadDataSource<SectionModel> {
        return RxTableViewSectionedReloadDataSource<SectionModel>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.identifier, for: indexPath) as! TransactionCell
                cell.configure(with: item)
                
                let isLastCell = tableView.numberOfRows(inSection: indexPath.section)-1 == indexPath.row
                if isLastCell {
                    cell.setupLastCell()
                }
                return cell
            })
    }
}

extension DashboardViewController: AddTransactionViewControllerDelegate {
    func didTransactionCreated() {
        Task {
            await viewModel.getTransactions(in: selectedMonthYear)
        }
    }
}

extension DashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TransactionSectionHeader.identifier) as? TransactionSectionHeader else {
            fatalError("Failed to create transaction header cell")
        }
        let date = dataSource[section].header.date
        let totalAmount = dataSource[section].header.totalAmount
        header.configure(date: date, totalAmount: totalAmount)
        return header
    }
}

