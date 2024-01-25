//
//  DetailTransactionViewController.swift
//  Mura
//
//  Created by Ferry Dwianta P on 16/01/24.
//

import UIKit
import RxSwift

protocol DetailTransactionViewControllerDelegate: AnyObject {
    func didTransactionChanged()
}

class DetailTransactionViewController: UIViewController {
    
    // MARK: - Variables
    private let viewModel: DetailTransactionViewModel
    private let transaction: Transaction
    private let disposeBag = DisposeBag()
    weak var delegate: DetailTransactionViewControllerDelegate?
    
    init(viewModel: DetailTransactionViewModel, transaction: Transaction) {
        self.viewModel = viewModel
        self.transaction = transaction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    private let loadingIndicator = LoadingIndicator()
    private let transactionFormView: TransactionFormTableView = {
        let table = TransactionFormTableView(formType: .edit)
        table.backgroundColor = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupView()
        
        transactionFormView.setFormData(transaction: transaction)
        
        observeDataChanges()
        addDeleteAction()
    }
    
    // MARK: - UI Setup
    private func setupNavBar() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        let addButton = UIBarButtonItem(title: "Update", style: .done, target: self, action: #selector(doneTapped))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = addButton
        navigationItem.title = "Detail"
        navigationItem.titleView?.tintColor = UIColor.textMain
        self.navigationController?.navigationBar.tintColor = UIColor.main
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.mainBg
        
        view.addSubview(transactionFormView)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            transactionFormView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            transactionFormView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            transactionFormView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            transactionFormView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
    }
    
    // MARK: - Setup Action
    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneTapped() {
        Task {
            var newTransaction = transactionFormView.getFormData()
            await viewModel.updateTransaction(old: transaction, new: &newTransaction)
        }
    }
    
    private func addDeleteAction() {
        transactionFormView.didDeleteTapped = {
            Alert.present(
                title: "Delete",
                message: "Are you sure delete this transaction?",
                actions: .close, .delete(handler: {
                    Task {
                        await self.viewModel.deleteTransaction(id: self.transaction.id)
                    }
                }),
                from: self
            )
        }
    }
    
    // MARK: - Observers
    func observeDataChanges() {
        viewModel.transactionChanged
            .observe(on: MainScheduler.instance)
            .subscribe (onNext: { [weak self] isCreated in
                self?.dismiss(animated: true, completion: nil)
                self?.delegate?.didTransactionChanged()
            })
            .disposed(by: disposeBag)
        
        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { error in
                if error is ValidationError {
                    Alert.present(
                        title: "Warning!",
                        message: (error as! ValidationError).message,
                        actions: .close,
                        from: self
                    )
                } else {
                    print(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator.startLoading()
                } else {
                    self?.loadingIndicator.stopLoading()
                }
            })
            .disposed(by: disposeBag)
    }
}

