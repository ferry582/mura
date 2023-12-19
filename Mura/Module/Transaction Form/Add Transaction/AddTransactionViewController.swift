//
//  AddTransactionViewController.swift
//  Mura
//
//  Created by Ferry Dwianta P on 08/10/23.
//

import UIKit
import RxSwift

class AddTransactionViewController: UIViewController {
    
    // MARK: - Variables
    private let viewModel: AddTransactionViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: AddTransactionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    private let transactionFormView: TransactionFormTableView = {
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
        
        viewModel.isTransactionCreated
            .subscribe (onNext: { [weak self] isCreated in
                if isCreated {
                    DispatchQueue.main.async {
                        self?.dismiss(animated: true, completion: nil)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.error
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
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneTapped() {
        Task {
            let transaction = transactionFormView.getFormData()
            await viewModel.createTransaction(data: transaction)
        }
    }
}
