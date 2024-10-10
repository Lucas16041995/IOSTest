//
//  NotificationManager.swift
//  IOSTest
//
//  Created by chiaowei on 2024/10/9.
//

import Foundation

/// 定義單筆通知訊息的結構體
struct NotificationMessage: Codable {
    var status: Bool               // 通知是否已讀狀態
    var updateDateTime: String      // 通知更新的日期與時間
    var title: String               // 通知標題
    var message: String             // 通知內容
}

/// 定義通知結果的結構體，包含多筆通知訊息的列表
struct NotificationResult: Codable {
    var messages: [NotificationMessage]  // 通知訊息的陣列
}

/// 定義最外層 JSON 結構的回應格式
struct NotificationResponse: Codable {
    var msgCode: String             // 回應碼
    var msgContent: String          // 回應訊息（如：成功或失敗的描述）
    var result: NotificationResult  // 回應結果，包含通知訊息的列表
}

/// NotificationManager 類別負責處理通知資料的抓取與解析
class NotificationManager {
    
    // 定義一個閉包，用於成功抓取通知資料後更新 UI
    var onNotificationsFetched: (([NotificationMessage]) -> Void)?
    
    // 定義一個閉包，用於發生錯誤時回傳錯誤訊息
    var onError: ((String) -> Void)?
    
    /// 從指定的 URL 抓取通知資料
    func fetchNotifications() {
        let urlString = "https://willywu0201.github.io/data/notificationList.json"
        
        // 檢查 URL 是否有效
        guard let url = URL(string: urlString) else {
            onError?("無效的 URL")
            return
        }
        
        // 建立 URLSession 資料請求
        URLSession.shared.dataTask(with: url) { data, response, error in
            // 若請求過程中發生錯誤，回傳錯誤訊息
            if let error = error {
                self.onError?("抓取通知資料失敗: \(error.localizedDescription)")
                return
            }
            
            // 確認資料是否存在
            guard let data = data else {
                self.onError?("未接收到任何資料。")
                return
            }
            
            // 使用 JSONDecoder 將資料解析為指定的結構體
            let decoder = JSONDecoder()
            
            do {
                // 將接收的 JSON 資料解碼為 NotificationResponse 結構體
                let notificationResponse = try decoder.decode(NotificationResponse.self, from: data)
                
                // 取出解析後的通知訊息列表，並透過閉包回傳
                let notifications = notificationResponse.result.messages
                self.onNotificationsFetched?(notifications)
                
            } catch {
                // 解碼失敗時，回傳錯誤訊息
                self.onError?("解析 JSON 失敗: \(error.localizedDescription)")
            }
        }.resume() // 開始執行資料請求
    }
}
