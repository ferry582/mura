//
//  DashboardView.swift
//  Mura
//
//  Created by Ferry Dwianta P on 17/07/23.
//

import UIKit

class DashboardHeaderView: UIView {
    
    // MARK: Variables
    var didTapDateButton: (() -> Void)? // Callback property handle date button when tapped
    var balancePercentText: NSMutableAttributedString = NSMutableAttributedString(string: "") {
        didSet {
            reportView.balancePercentText = balancePercentText
        }
    }
    var monthYearText: String = "" {
        didSet {
            dateButton.setTitle(monthYearText, for: .normal)
        }
    }
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setupAction()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    private let dateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Date().convertToMonthYearString(), for: .normal)
        button.setTitleColor(UIColor.main, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.backgroundColor = UIColor.main20
        button.layer.cornerRadius = 10.0
        button.layer.masksToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let reportView: ReportView = {
        let view = ReportView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let transactionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "Transactions"
        label.textColor = UIColor.textMain
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - UI Set Up
    private func setupView() {
        self.addSubview(dateButton)
        self.addSubview(reportView)
        self.addSubview(transactionTitleLabel)
        
        NSLayoutConstraint.activate([
            dateButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            dateButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dateButton.heightAnchor.constraint(equalToConstant: 27),

            reportView.topAnchor.constraint(equalTo: dateButton.bottomAnchor, constant: 15),
            reportView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            reportView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            transactionTitleLabel.topAnchor.constraint(equalTo: reportView.bottomAnchor, constant: 25),
            transactionTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            transactionTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            
        ])
    }
    
    // MARK: - Setup Action
    private func setupAction() {
        dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        
    }
    
    @objc private func dateButtonTapped() {
        didTapDateButton?()
    }
    
}


