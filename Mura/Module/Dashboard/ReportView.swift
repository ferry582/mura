//
//  ReportView.swift
//  Mura
//
//  Created by Ferry Dwianta P on 24/09/23.
//

import UIKit

class ReportView: UIView {
    
    // MARK: Variables
    var balancePercentText: NSMutableAttributedString = NSMutableAttributedString(string: "") {
        didSet {
            balancePercentageLabel.attributedText = balancePercentText
        }
    }
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configReportUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - UI Components
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
    
    // MARK: - UI Set Up
    private func setupView() {
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
        
        self.addSubview(vstackBalanceCard)
        self.addSubview(hstackExpenseIncomeCard)
        
        NSLayoutConstraint.activate([
            vstackBalanceCard.topAnchor.constraint(equalTo: topAnchor),
            vstackBalanceCard.leadingAnchor.constraint(equalTo: leadingAnchor),
            vstackBalanceCard.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            hstackExpenseIncomeCard.topAnchor.constraint(equalTo: vstackBalanceCard.bottomAnchor, constant: 15),
            hstackExpenseIncomeCard.leadingAnchor.constraint(equalTo: leadingAnchor),
            hstackExpenseIncomeCard.trailingAnchor.constraint(equalTo: trailingAnchor),
            hstackExpenseIncomeCard.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            expenseIconImage.heightAnchor.constraint(equalToConstant: 25),
            expenseIconImage.widthAnchor.constraint(equalToConstant: 25),
            
            incomeIconImage.heightAnchor.constraint(equalToConstant: 25),
            incomeIconImage.widthAnchor.constraint(equalToConstant: 25),
            
        ])
        
    }
    
    private func configReportUI() {
        self.chartIconImage.setImageColor(color: UIColor.main)
        self.expenseIconImage.setImageColor(color: UIColor.main)
        self.incomeIconImage.setImageColor(color: UIColor.main)
    }
    
}



