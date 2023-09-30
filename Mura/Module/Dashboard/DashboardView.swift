//
//  DashboardView.swift
//  Mura
//
//  Created by Ferry Dwianta P on 17/07/23.
//

import UIKit
import MonthYearWheelPicker

class DashboardView: UIView {
    
    // MARK: Variables
    var balancePercentText: NSMutableAttributedString = NSMutableAttributedString(string: "") {
        didSet {
            reportView.balancePercentText = balancePercentText
        }
    }
    private var datePickerBottomConstraint: NSLayoutConstraint?
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setupDashboardUI()
        self.setupAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    private let dateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Date().convertToString(), for: .normal)
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
    
    private let monthYearDatePicker: MonthYearWheelPicker = {
        let picker = MonthYearWheelPicker()
        var dateComponents = DateComponents()
        let userCalendar = Calendar(identifier: .gregorian)
        picker.backgroundColor = UIColor.cardBg
        picker.isHidden = true
        dateComponents.year = 2015
        dateComponents.month = 1
        picker.minimumDate = userCalendar.date(from: dateComponents)! // Value of minDate should be the oldest transaction on db
        dateComponents.year = 1
        picker.maximumDate = Calendar.current.date(byAdding: dateComponents, to: Date())!
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let toolbar: UIToolbar = {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.isHidden = true
        toolbar.tintColor = UIColor.main
        toolbar.barTintColor = UIColor.cardBg
        toolbar.isTranslucent = false
        toolbar.setItems([cancelButton, flexSpace, doneButton], animated: true)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    // MARK: - UI Set Up
    private func setupView() {
        self.addSubview(dateButton)
        self.addSubview(reportView)
        self.addSubview(monthYearDatePicker)
        self.addSubview(toolbar)
        
        datePickerBottomConstraint = monthYearDatePicker.bottomAnchor.constraint(equalTo: bottomAnchor, constant: monthYearDatePicker.frame.height)
        
        NSLayoutConstraint.activate([
            dateButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            dateButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            dateButton.heightAnchor.constraint(equalToConstant: 27),
            
            reportView.topAnchor.constraint(equalTo: dateButton.bottomAnchor, constant: 15),
            reportView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            reportView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            monthYearDatePicker.leadingAnchor.constraint(equalTo: leadingAnchor),
            monthYearDatePicker.trailingAnchor.constraint(equalTo: trailingAnchor),
            datePickerBottomConstraint!,
            
            toolbar.bottomAnchor.constraint(equalTo: monthYearDatePicker.topAnchor),
            toolbar.leadingAnchor.constraint(equalTo: leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func setupDashboardUI() {
        
    }
    
    // MARK: - Setup Action
    private func setupAction() {
        dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        
    }
    
    @objc private func dateButtonTapped() {
        monthYearDatePicker.isHidden = false
        toolbar.isHidden = false
        animateDatePicker(to: 0)
    }
    
    @objc func doneButtonTapped() {
        self.dateButton.setTitle("\(monthYearDatePicker.date.convertToString())", for: .normal)
        animateDatePicker(to: self.monthYearDatePicker.frame.height) { _ in
            self.monthYearDatePicker.isHidden = true
            self.toolbar.isHidden = true
        }
    }

    @objc func cancelButtonTapped() {
        animateDatePicker(to: self.monthYearDatePicker.frame.height) { _ in
            self.monthYearDatePicker.isHidden = true
            self.toolbar.isHidden = true
        }
    }
    
    private func animateDatePicker(to constant: CGFloat, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.datePickerBottomConstraint?.constant = constant
            self.layoutIfNeeded()
        }, completion: completion)
    }
    
}


