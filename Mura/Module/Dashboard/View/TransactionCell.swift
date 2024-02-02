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
    private var iconBgBottomConstraint: NSLayoutConstraint?
    
    // MARK: - UI Components
    private let transactionIconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "fork.knife")
        iv.tintColor = UIColor.main
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let transactionIconBg: UIView = {
        let iv = UIView()
        iv.layer.cornerRadius = 12
        iv.backgroundColor = UIColor.main20
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCellAppearance()
    }
    
    // MARK: - UI Set Up
    private func setupView() {
        contentView.backgroundColor = UIColor.cardBg
        
        vstackCategoryNoteLabel.addArrangedSubview(categoryLabel)
        vstackCategoryNoteLabel.addArrangedSubview(noteLabel)
        
        contentView.addSubview(transactionIconBg)
        contentView.addSubview(transactionIconImage)
        contentView.addSubview(vstackCategoryNoteLabel)
        contentView.addSubview(amountLabel)
        
        iconBgBottomConstraint = transactionIconBg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        
        NSLayoutConstraint.activate([
            transactionIconBg.widthAnchor.constraint(equalToConstant: 40),
            transactionIconBg.heightAnchor.constraint(equalToConstant: 40),
            transactionIconBg.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            transactionIconBg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            iconBgBottomConstraint!,
            
            transactionIconImage.centerYAnchor.constraint(equalTo: transactionIconBg.centerYAnchor),
            transactionIconImage.centerXAnchor.constraint(equalTo: transactionIconBg.centerXAnchor),
            
            vstackCategoryNoteLabel.centerYAnchor.constraint(equalTo: transactionIconBg.centerYAnchor),
            vstackCategoryNoteLabel.leadingAnchor.constraint(equalTo: transactionIconBg.trailingAnchor, constant: 10),
            
            amountLabel.centerYAnchor.constraint(equalTo: transactionIconBg.centerYAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
        
    }
    
    private func resetCellAppearance() {
        self.layer.cornerRadius = 0
        self.clipsToBounds = false
        self.layer.maskedCorners = []
        iconBgBottomConstraint?.constant = 0
    }
    
    func setupLastCell() {
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        iconBgBottomConstraint?.constant = -12
    }
    
    func configure(with transaction: Transaction) {
        self.categoryLabel.text = transaction.category.name
        self.transactionIconImage.image = UIImage(systemName: transaction.category.icon)
        self.amountLabel.text = transaction.amount.formatToLocalizedDecimal()
        
        if transaction.amount < 0 {
            amountLabel.textColor = UIColor.negativeAmount
        } else {
            amountLabel.textColor = UIColor.main
        }
    }
}

