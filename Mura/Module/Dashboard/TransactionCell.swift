//
//  TransactionCell.swift
//  Mura
//
//  Created by Ferry Dwianta P on 01/10/23.
//

import UIKit

class TransactionCell: UITableViewCell {
    
    // MARK: - Variables
    static let identifier = "TransactionCell"
    
    // MARK: - UI Components
    private let transactionIconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "IncomeIcon")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "Foods & Beverage"
        label.textColor = UIColor.textMain
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "Breakfast"
        label.textColor = UIColor.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let vstackCategoryNoteLabel: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "-78.000"
        label.textColor = UIColor.textMain
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Set Up
    private func setupView() {
        contentView.backgroundColor = UIColor.cardBg
        
        vstackCategoryNoteLabel.addArrangedSubview(categoryLabel)
        vstackCategoryNoteLabel.addArrangedSubview(noteLabel)
        
        contentView.addSubview(transactionIconImage)
        contentView.addSubview(vstackCategoryNoteLabel)
        contentView.addSubview(amountLabel)
        
        NSLayoutConstraint.activate([
            transactionIconImage.widthAnchor.constraint(equalToConstant: 40),
            transactionIconImage.heightAnchor.constraint(equalToConstant: 40),
            transactionIconImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            transactionIconImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            transactionIconImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            vstackCategoryNoteLabel.centerYAnchor.constraint(equalTo: transactionIconImage.centerYAnchor),
            vstackCategoryNoteLabel.leadingAnchor.constraint(equalTo: transactionIconImage.trailingAnchor, constant: 10),
            
            amountLabel.centerYAnchor.constraint(equalTo: transactionIconImage.centerYAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
        
    }
    
    func setupLastCell() {
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        self.transactionIconImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
    }
    
    func configure(with transaction: Transaction) {
        self.categoryLabel.text = switch transaction.category {
        case .income(let incomeCategory):
            incomeCategory.rawValue
        case .expense(let expenseCategory):
            expenseCategory.rawValue
        }
        self.amountLabel.text = String(transaction.amount)
        
        if transaction.amount < 0 {
            amountLabel.textColor = UIColor.negativeAmount
        } else {
            amountLabel.textColor = UIColor.main
        }
        
        if transaction.type == .expense {
            self.transactionIconImage.image = UIImage(named: "ExpenseIcon")
            self.transactionIconImage.setImageColor(color: UIColor.main)
        } else {
            self.transactionIconImage.image = UIImage(named: "IncomeIcon")
            self.transactionIconImage.setImageColor(color: UIColor.main)
        }
    }
}
