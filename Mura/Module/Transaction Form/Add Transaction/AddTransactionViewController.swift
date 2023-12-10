//
//  AddTransactionViewController.swift
//  Mura
//
//  Created by Ferry Dwianta P on 08/10/23.
//

import UIKit
import CoreData

class AddTransactionViewController: UIViewController {
    
    // MARK: - Variables
    
    // MARK: - UI Components
    private let transactionFormView: UITableView = {
        let table = TransactionFormTableView(formType: .add)
        table.backgroundColor = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupView()
    }
    
    // MARK: - UI Setup
    private func setupNavBar() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        let addButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(doneTapped))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = addButton
        navigationItem.title = "New Transaction"
        navigationItem.titleView?.tintColor = UIColor.textMain
        self.navigationController?.navigationBar.tintColor = UIColor.main
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.mainBg
        
        view.addSubview(transactionFormView)
        
        NSLayoutConstraint.activate([
            transactionFormView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            transactionFormView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            transactionFormView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            transactionFormView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
    }
    
    // MARK: - Setup Action
    @objc func cancelTapped() {
        // Handle cancel action
        dismiss(animated: true, completion: nil)
        
        Task {
            do {
                let data = try await TransactionCoreDataSourceImpl().getAll()
                print(data)
            } catch {
                print(error)
            }
        }
        
    }
    
    @objc func doneTapped() {
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // test core data with clean architecture
        let vm = AddTransactionViewModel()
        let data: Transaction = Transaction(id: UUID(), date: Date(), category: .expense(.food), note: "listrik", amount: 123.4, type: TransactionType.income)
        Task {
            await vm.createTransaction(data: data)
        }
        
        // tableview reload data
        
        dismiss(animated: true, completion: nil)
    }
    
}
