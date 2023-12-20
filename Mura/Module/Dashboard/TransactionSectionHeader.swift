//
//  TransactionCellHeader.swift
//  Mura
//
//  Created by Ferry Dwianta P on 01/10/23.
//

import UIKit

class TransactionSectionHeader: UITableViewHeaderFooterView {

    // MARK: - Variables
    static let identifier = "TransactionSectionHeader"
    
    // MARK: - UI Components
    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.cardBg
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.text = "00"
        label.textColor = UIColor.textMain
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let monthYearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "March 2023"
        label.textColor = UIColor.textMain
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dayNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "Saturday"
        label.textColor = UIColor.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let vstackDateLabel: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let totalAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "-78.000"
        label.textColor = UIColor.textMain
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - UI Set Up
    private func setupView() {
        vstackDateLabel.addArrangedSubview(monthYearLabel)
        vstackDateLabel.addArrangedSubview(dayNameLabel)
        
        contentView.addSubview(bgView)
        contentView.addSubview(dayLabel)
        contentView.addSubview(vstackDateLabel)
        contentView.addSubview(totalAmountLabel)
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            separatorView.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: 0),
            separatorView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 12),
            separatorView.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -12),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            dayLabel.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 12),
            dayLabel.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -12),
            dayLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 12),
            
            vstackDateLabel.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            vstackDateLabel.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 10),
            
            totalAmountLabel.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            totalAmountLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -12)
            
        ])
            
    }
    
    public func configure(date: Date, totalAmount: Double) {
        self.dayLabel.text = date.convertToDayString()
        self.monthYearLabel.text = date.convertToMonthYearString()
        self.dayNameLabel.text = date.convertToDayNameString()
        self.totalAmountLabel.text = "100"
        self.setupView()
    }

}
