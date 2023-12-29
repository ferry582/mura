//
//  ToolBar.swift
//  Mura
//
//  Created by Ferry Dwianta P on 29/12/23.
//

import UIKit

class AccessoryToolbar: UIToolbar {
    var doneAction: (() -> Void)?
    var cancelAction: (() -> Void)?
    
    private let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
    private let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        sizeToFit()
        tintColor = UIColor.main
        barTintColor = UIColor.cardBg
        isTranslucent = false
        setItems([flexSpace, doneButton], animated: true)
    }
    
    @objc private func doneButtonTapped() {
        doneAction?()
    }
    
    @objc private func cancelButtonTapped() {
        cancelAction?()
    }
    
    func hasCancelButton() {
        setItems([cancelButton, flexSpace, doneButton], animated: true)
    }
}
