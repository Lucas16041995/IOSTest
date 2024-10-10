//
//  ADBannerManager.swift
//  IOSTest
//
//  Created by chiaowei on 2024/10/9.
//

import Foundation

struct ADBanner: Codable {
    var msgCode: String
    var msgContent: String
    var result: ADResultData
}

struct ADResultData: Codable {
    var bannerList: [BannerList]
}

// 儲蓄帳戶的資料結構
struct BannerList: Codable {
    var adSeqNo: Int
    var linkUrl: String
}



class ADBannerManager {
    
    var onImageURL: (([String]) -> Void)?
    
    func fetchADBannerData() {
        let url = "https://willywu0201.github.io/data/banner.json"
        fetchData(from: url) { (result: ADBanner?) in
            guard let bannersList = result?.result.bannerList else { return }
            
                // 收集所有的廣告圖片 URL
                let bannerURLs = bannersList.map { $0.linkUrl }
                        
            print("ADBannerManager: \(bannerURLs)")
                // 在主線程中回傳 URL 列表
            DispatchQueue.main.async {
                self.onImageURL?(bannerURLs)
            }
        }
    }
    
    private func fetchData<T: Codable>(from urlString: String, completion: @escaping (T?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("無效的 URL")
            completion(nil)
            return
        }
        
        // 發起 URL 請求
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("抓取資料失敗：\(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("沒有收到資料。")
                completion(nil)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                // 將資料解碼為指定的結構
                let item = try decoder.decode(T.self, from: data)
                completion(item)
            } catch {
                print("ADBanner JSON 解碼失敗：\(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}
