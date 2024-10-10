//
//  CustomAmountLabel.swift
//  IOSTest
//
//  Created by chiaowei on 2024/10/9.
//

import UIKit

class CustomAmountView: UIView {
    
    // Property to control secure text entry
    var isSecureTextEntry: Bool = false {
        didSet {
            updateAmountLabel()
        }
    }
    
    // The original amount value (hidden or not)
    private var originalAmount: String = ""
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textColor = UIColor(red: 68 / 255, green:  68 / 255, blue:  68 / 255, alpha: 1)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }
    
    private func setupLabel() {
        // Apply gradient background
        applyGradientBackground()
        // Add the label to the view
        addSubview(amountLabel)
        
        NSLayoutConstraint.activate([
            amountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // Add gradient background to the label
    private func applyGradientBackground() {
        self.layer.cornerRadius = 6
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1).cgColor,
            UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds
        
        // Add the gradient layer and adjust layout
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure the gradient layer frame is updated when the label's layout changes
        if let gradientLayer = self.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = self.bounds
        }
    }
    
    // Set the amount and update the label text based on secure text entry setting
    func setAmount(_ amount: String) {
        originalAmount = amount
        updateAmountLabel()
    }
    
    // Update label text based on the isSecureTextEntry property
    private func updateAmountLabel() {
        if isSecureTextEntry {
            amountLabel.text = String(repeating: "*", count: originalAmount.count)
        } else {
            amountLabel.text = originalAmount
        }
    }
}
