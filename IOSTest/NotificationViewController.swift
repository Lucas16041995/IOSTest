//
//  NotificationViewController.swift
//  IOSTest
//
//  Created by chiaowei on 2024/10/9.
//

import UIKit

class NotificationViewController: UIViewController {
    
    // 建立 NotificationManager 實例來負責抓取通知資料
    private let notificationManager = NotificationManager()
    
    // 標題標籤（顯示 "Notification"）
    lazy var notificationLabel: UILabel = {
        let label = UILabel()
        label.text = "Notification"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor(red: 26 / 255, green: 26 / 255, blue: 26 / 255, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 返回按鈕（左上角的返回圖示）
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "iconArrowWTailBack"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 滾動視圖用來包含通知的堆疊視圖
    lazy var notificationScroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    // 垂直堆疊視圖（顯示所有通知訊息）
    lazy var notificationStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // 下拉刷新控制項（UIRefreshControl）
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .gray
        control.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return control
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設定畫面 UI 佈局
        setNotificationView()
        
        // 設定 NotificationManager 的資料抓取成功和錯誤回呼處理
        setupNotificationManager()
    }
    
    /// 設定畫面佈局與 UI 元件
    private func setNotificationView() {
        self.view.backgroundColor = UIColor(red: 250 / 255, green: 250 / 255, blue: 250 / 255, alpha: 1)
        
        // 加入標題標籤與返回按鈕到主視圖
        self.view.addSubview(notificationLabel)
        self.view.addSubview(backButton)
        
        // 加入滾動視圖與堆疊視圖到主視圖
        self.view.addSubview(notificationScroll)
        notificationScroll.addSubview(notificationStack)
        
        // 將下拉刷新控制項加入到滾動視圖
        notificationScroll.refreshControl = refreshControl
        
        // 設定返回按鈕點擊事件
        backButton.addTarget(self, action: #selector(tappedTheBackButton), for: .touchUpInside)
        
        // 設定 Auto Layout 約束
        NSLayoutConstraint.activate([
            notificationLabel.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            notificationLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            backButton.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            backButton.centerYAnchor.constraint(equalTo: notificationLabel.centerYAnchor),
            
            notificationScroll.topAnchor.constraint(equalTo: notificationLabel.bottomAnchor, constant: 10),
            notificationScroll.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            notificationScroll.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            notificationScroll.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
            
            notificationStack.topAnchor.constraint(equalTo: notificationScroll.topAnchor),
            notificationStack.leadingAnchor.constraint(equalTo: notificationScroll.leadingAnchor),
            notificationStack.trailingAnchor.constraint(equalTo: notificationScroll.trailingAnchor),
            notificationStack.bottomAnchor.constraint(equalTo: notificationScroll.bottomAnchor),
            notificationStack.widthAnchor.constraint(equalTo: notificationScroll.widthAnchor),
        ])
    }
    
    /// 設定 NotificationManager 抓取資料的回呼與錯誤處理
    private func setupNotificationManager() {
        // 成功抓取通知資料時，更新通知列表
        notificationManager.onNotificationsFetched = { [weak self] notifications in
            DispatchQueue.main.async {
                self?.updateNotificationList(with: notifications)
                // 停止下拉刷新動畫
                self?.refreshControl.endRefreshing()
            }
        }
        
        // 當發生錯誤時，顯示錯誤訊息或執行其他處理
        notificationManager.onError = { [weak self] errorMessage in
            print("錯誤: \(errorMessage)")
            // 停止下拉刷新動畫
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
            // 這裡可以顯示錯誤訊息給使用者（例如：UIAlertController）
        }
    }
    
    /// 返回按鈕點擊事件處理
    @objc func tappedTheBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// 下拉刷新處理事件
    @objc private func handleRefresh() {
        print("正在刷新通知...")
        // 下拉刷新時，從 API 重新抓取通知資料
        notificationManager.fetchNotifications()
    }
    
    /// 更新通知列表
    /// - Parameter notifications: 抓取到的通知資料陣列
    private func updateNotificationList(with notifications: [NotificationMessage]) {
        // 清空先前的所有通知項目
        notificationStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 使用 CustomNotificationView 顯示每筆通知
        for notification in notifications {
            let notificationView = createNotificationView(for: notification)
            notificationStack.addArrangedSubview(notificationView)
        }
    }
    
    /// 創建每筆通知項目的自訂視圖
    /// - Parameter notification: 單筆通知資料
    /// - Returns: 自訂通知視圖（UIView）
    private func createNotificationView(for notification: NotificationMessage) -> CustomNotificationView {
        // 使用 CustomNotificationView 替代原來的 UIView
        let customView = CustomNotificationView()
        customView.translatesAutoresizingMaskIntoConstraints = false

        // 設置 CustomNotificationView 的內容
        customView.configure(title: notification.title,
                             date: notification.updateDateTime,
                             content: notification.message, status: notification.status)
        
        return customView
    }
}
