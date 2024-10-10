//
//  FavoriteManager.swift
//  IOSTest
//
//  Created by chiaowei on 2024/10/9.
//

import Foundation

struct FavoriteResult: Codable {
    var msgCode: String
    var msgContent: String
    var result: FavoriteResultData
}

struct FavoriteResultData: Codable {
    var favoriteList: [FavoriteList]
}

// 儲蓄帳戶的資料結構
struct FavoriteList: Codable {
    var nickname: String
    var transType: String
}

class FavoriteManager {
    
    var onNickName: (([String]) -> Void)?
    var onTranType: (([String]) -> Void)?
    
    func fetchFavoriteData() {
        let url = "https://willywu0201.github.io/data/favoriteList.json"
        fetchData(from: url) { (result: FavoriteResult?) in
            guard let favoriteList = result?.result.favoriteList else { return }
           
            let nickName = favoriteList.map { $0.nickname }
            
            let transTypes = favoriteList.map { $0.transType }
            
            print("nick name: \(nickName)")
            
            print("tranTypes: \(transTypes)")
            
            DispatchQueue.main.async {
                self.onNickName?(nickName)
                self.onTranType?(transTypes)
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
