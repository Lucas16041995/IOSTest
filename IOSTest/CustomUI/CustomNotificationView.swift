//
//  CustomNotificationView.swift
//  IOSTest
//
//  Created by chiaowei on 2024/10/8.
//

import UIKit

class CustomNotificationView: UIView {
    
    // 點標記（dotView）用來顯示通知類別
    lazy var dotView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(red: 255 / 255, green: 136 / 255, blue: 97 / 255 , alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 標題標籤
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold) // 使用系統字體
        label.textColor = UIColor(red: 26 / 255, green: 26 / 255, blue: 26 / 255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 日期標籤
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular) // 使用系統字體
        label.textColor = UIColor(red: 26 / 255, green: 26 / 255, blue: 26 / 255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 內容標籤
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular) // 使用系統字體
        label.textColor = UIColor(red: 115 / 255, green: 116 / 255, blue: 126 / 255, alpha: 1)
        label.numberOfLines = 0 // 允許多行文字
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // 初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setNotificationView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setNotificationView()
    }
    
    // 設定通知視圖：加入元件並設置 Auto Layout
    private func setNotificationView(){
        // 加入所有子視圖
        addSubview(dotView)
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(contentLabel)
        
        // 設定 Auto Layout 約束
        NSLayoutConstraint.activate([
            // dotView 設定
            dotView.widthAnchor.constraint(equalToConstant: 12),
            dotView.heightAnchor.constraint(equalToConstant: 12),
            dotView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            dotView.topAnchor.constraint(equalTo: self.topAnchor, constant: 22),
            
            // titleLabel 設定
            titleLabel.leadingAnchor.constraint(equalTo: dotView.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            // dateLabel 設定
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // contentLabel 設定
            contentLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            contentLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16) // 與底部對齊
        ])
    }
    
    // 設定視圖內容
    func configure(title: String, date: String, content: String, status: Bool) {
        titleLabel.text = title
        dateLabel.text = date
        contentLabel.text = content
        
        if status == true{
            dotView.backgroundColor = .clear
        }else {
            dotView.backgroundColor = UIColor(red: 255 / 255, green: 136 / 255, blue: 97 / 255 , alpha: 1)
        }
    }
}
