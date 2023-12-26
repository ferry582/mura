//
//  DashboardView.swift
//  Mura
//
//  Created by Ferry Dwianta P on 17/07/23.
//

import UIKit

class DashboardHeaderView: UIView {
    
    // MARK: Variables
    var didTapDateButton: (() -> Void)?
    var balancePercentText: NSMutableAttributedString = NSMutableAttributedString(string: "") {
        didSet {
            balancePercentageLabel.attributedText = balancePercentText
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
        setupView()
        setupAction()
        configReportUI()
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
    
    private let balanceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "BALANCE"
        label.textColor = UIColor.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let balanceAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.text = "Rp300.000"
        label.textColor = UIColor.textMain
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chartIconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "ChartPositiveIcon")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let balancePercentageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.text = "30% from february"
        label.textColor = UIColor.textMain
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let hstackBalancePercentage: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 5
        return sv
    }()
    
    private let vstackBalanceCard: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .leading
        sv.distribution = .fill
        sv.spacing = 5
        sv.backgroundColor = UIColor.cardBg
        sv.layer.cornerRadius = 15
        sv.clipsToBounds = true
        sv.isLayoutMarginsRelativeArrangement = true
        sv.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let expenseIconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "ExpenseIcon")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let vstackExpenseIcon: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .trailing
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let expenseTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "EXPENSE"
        label.textColor = UIColor.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let expenseAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.text = "Rp300.000"
        label.textColor = UIColor.textMain
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let vstackExpenseCard: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 3
        sv.backgroundColor = UIColor.cardBg
        sv.layer.cornerRadius = 15
        sv.clipsToBounds = true
        sv.isLayoutMarginsRelativeArrangement = true
        sv.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let incomeIconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "IncomeIcon")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let vstackIncomeIcon: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .trailing
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let incomeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "INCOME"
        label.textColor = UIColor.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let incomeAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.text = "Rp300.000"
        label.textColor = UIColor.textMain
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let vstackIncomeCard: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 3
        sv.backgroundColor = UIColor.cardBg
        sv.layer.cornerRadius = 15
        sv.clipsToBounds = true
        sv.isLayoutMarginsRelativeArrangement = true
        sv.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let hstackExpenseIncomeCard: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 15
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
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
        
        // Balance Card StackView
        hstackBalancePercentage.addArrangedSubview(chartIconImage)
        hstackBalancePercentage.addArrangedSubview(balancePercentageLabel)
        
        vstackBalanceCard.addArrangedSubview(balanceTitleLabel)
        vstackBalanceCard.addArrangedSubview(balanceAmountLabel)
        vstackBalanceCard.addArrangedSubview(hstackBalancePercentage)
        
        // Expense Card StackView
        vstackExpenseIcon.addArrangedSubview(expenseIconImage) // Set icon equal to vstackExpenseCard trailing
        [vstackExpenseIcon, expenseTitleLabel, expenseAmountLabel].forEach {vstackExpenseCard.addArrangedSubview($0)}
        
        // Income Card StackView
        vstackIncomeIcon.addArrangedSubview(incomeIconImage) // Set icon equal to vstackIncomeCard trailing
        [vstackIncomeIcon, incomeTitleLabel, incomeAmountLabel].forEach {vstackIncomeCard.addArrangedSubview($0)}
        
        // Expense and Income HStackView
        hstackExpenseIncomeCard.addArrangedSubview(vstackExpenseCard)
        hstackExpenseIncomeCard.addArrangedSubview(vstackIncomeCard)
        
        addSubview(vstackBalanceCard)
        addSubview(hstackExpenseIncomeCard)
        addSubview(transactionTitleLabel)
        
        NSLayoutConstraint.activate([
            dateButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            dateButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            dateButton.heightAnchor.constraint(equalToConstant: 27),
            
            vstackBalanceCard.topAnchor.constraint(equalTo: dateButton.bottomAnchor, constant: 15),
            vstackBalanceCard.leadingAnchor.constraint(equalTo: leadingAnchor),
            vstackBalanceCard.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            hstackExpenseIncomeCard.topAnchor.constraint(equalTo: vstackBalanceCard.bottomAnchor, constant: 15),
            hstackExpenseIncomeCard.leadingAnchor.constraint(equalTo: leadingAnchor),
            hstackExpenseIncomeCard.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            expenseIconImage.heightAnchor.constraint(equalToConstant: 25),
            expenseIconImage.widthAnchor.constraint(equalToConstant: 25),
            
            incomeIconImage.heightAnchor.constraint(equalToConstant: 25),
            incomeIconImage.widthAnchor.constraint(equalToConstant: 25),
            
            transactionTitleLabel.topAnchor.constraint(equalTo: hstackExpenseIncomeCard.bottomAnchor, constant: 25),
            transactionTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            transactionTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            
        ])
    }
    
    private func configReportUI() {
        self.chartIconImage.setImageColor(color: UIColor.main)
        self.expenseIconImage.setImageColor(color: UIColor.main)
        self.incomeIconImage.setImageColor(color: UIColor.main)
    }
    
    // MARK: - Setup Action
    private func setupAction() {
        dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        
    }
    
    @objc private func dateButtonTapped() {
        didTapDateButton?()
    }
    
}


