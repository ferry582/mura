//
//  ViewController.swift
//  Mura
//
//  Created by Ferry Dwianta P on 29/06/23.
//

import UIKit

class DashboardViewController: UIViewController {

    // MARK: - Variables
    private let reportViewModel: ReportViewModel
    
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
        
        dashboardView.balancePercentText = reportViewModel.getBalancePercentText()
    }
    
    // MARK: - UI Components
    private let dashboardView: DashboardView = {
        let view = DashboardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - UI Setup
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.textMain]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.textMain]
        
        navigationItem.title = "Home"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.main
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.mainBg
        
        view.addSubview(dashboardView)
        
        NSLayoutConstraint.activate([
            dashboardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dashboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dashboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dashboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
    
    // MARK: - Setup Action
    @objc private func addTapped() {
        print("add button tapped")
    }

}

