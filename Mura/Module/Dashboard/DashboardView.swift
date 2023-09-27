//
//  HomeView.swift
//  Mura
//
//  Created by Ferry Dwianta P on 17/07/23.
//

import UIKit

class DashboardView: UIView {
    
    // MARK: Variables
    private var monthYearText: String = "March 2023" {
        didSet {
            dateButton.setTitle(monthYearText, for: .normal)
        }
    }
    
    var balancePercentText: NSMutableAttributedString = NSMutableAttributedString(string: "") {
        didSet {
            reportView.balancePercentText = balancePercentText
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
        let button = UIButton()
        button.setTitle("Month Year", for: .normal)
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
    
    // MARK: - UI Set Up
    private func setupView() {
        self.addSubview(dateButton)
        self.addSubview(reportView)
        
        NSLayoutConstraint.activate([
            dateButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            dateButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            dateButton.heightAnchor.constraint(equalToConstant: 27),
            
            reportView.topAnchor.constraint(equalTo: dateButton.bottomAnchor, constant: 15),
            reportView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            reportView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
        ])
    }
    
    // MARK: - Setup Action
    private func setupAction() {
        dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
    }
    
    @objc private func dateButtonTapped() {
        print("dateButtonClicked")
        monthYearText = "March 2023"
    }
    
}


