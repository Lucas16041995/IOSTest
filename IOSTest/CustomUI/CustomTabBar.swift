//
//  CustomTabBar.swift
//  IOSTest
//
//  Created by chiaowei on 2024/10/9.
//

import UIKit

class CustomTabBar: UIView {

    private let buttonTitles = ["Home", "Account", "Location", "Service"]
        private let buttonImages = ["icTabbarHomeActive", "icTabbarAccountDefault", "icTabbarLocationActive", "customers"] // Replace with your images
        
        private var buttons: [UIButton] = []
        var buttonTapHandler: ((Int) -> Void)?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupView()
        }
        
        private func setupView() {
            backgroundColor = .white
            layer.cornerRadius = 16
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.1
            layer.shadowOffset = CGSize(width: 0, height: 1)
            layer.shadowRadius = 8
            translatesAutoresizingMaskIntoConstraints = false
            
            createButtons()
            configureStackView()
        }
        
        // Create the buttons
        private func createButtons() {
            for (index, title) in buttonTitles.enumerated() {
                let button = UIButton(type: .system)
                button.setImage(UIImage(named: buttonImages[index]), for: .normal)
                button.setTitle(title, for: .normal)
                button.tintColor = index == 0 ? .orange : .lightGray
                button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                button.setTitleColor(index == 0 ? .orange : .lightGray, for: .normal)
                button.tag = index // Set tag to identify the button
                
                // Configure the button's image and title layout
                button.titleEdgeInsets = UIEdgeInsets(top: 30, left: -40, bottom: 0, right: 0)
                button.imageEdgeInsets = UIEdgeInsets(top: -20, left: 10, bottom: 0, right: 0)
                
                buttons.append(button)
            }
        }
        
        // Set up the stack view for buttons
        private func configureStackView() {
            let stackView = UIStackView(arrangedSubviews: buttons)
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 16
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(stackView)
            
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
                stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
                stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
            ])
        }
        
     
}
