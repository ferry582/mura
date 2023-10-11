//
//  AddTransactionViewController.swift
//  Mura
//
//  Created by Ferry Dwianta P on 08/10/23.
//

import UIKit

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
    }
    
    @objc func doneTapped() {
        // Handle done action
        dismiss(animated: true, completion: nil)
    }
    
}
