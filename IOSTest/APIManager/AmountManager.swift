//
//  AccountManager.swift
//  IOSTest
//
//  Created by chiaowei on 2024/10/9.
//



import Foundation

// 定義結構體來表示儲蓄帳戶的資料
struct USDAmount: Codable {
    var msgCode: String
    var msgContent: String
    var result: ResultData
}

struct ResultData: Codable {
    var savingsList: [SavingsList]
}

// 儲蓄帳戶的資料結構
struct SavingsList: Codable {
    var account: String
    var curr: String // 使用 curr 欄位來判斷幣別
    var balance: Double
}

// 定義結構體來表示定期存款帳戶的資料
struct FixedUSDAmount: Codable {
    var msgCode: String
    var msgContent: String
    var result: FixedResultData
}

struct FixedResultData: Codable {
    var fixedDepositList: [FixedList]
}

// 定期存款帳戶的資料結構
struct FixedList: Codable {
    var account: String
    var curr: String // 使用 curr 欄位來判斷幣別
    var balance: Double
}

// 定義結構體來表示數位帳戶的資料
struct DigitalUSDAmount: Codable {
    var msgCode: String
    var msgContent: String
    var result: DigitalResultData
}

struct DigitalResultData: Codable {
    var digitalList: [DigitalList]
}

// 數位帳戶的資料結構
struct DigitalList: Codable {
    var account: String
    var curr: String // 使用 curr 欄位來判斷幣別
    var balance: Double
}

class AmountManager {
    // 儲存每種類型帳戶的餘額（USD）
    private var savingsUSDBalance: Double = 0.0
    private var fixedDepositsUSDBalance: Double = 0.0
    private var digitalUSDBalance: Double = 0.0
    
    // 儲存每種類型帳戶的餘額（KHR）
    private var savingsKHRBalance: Double = 0.0
    private var fixedDepositsKHRBalance: Double = 0.0
    private var digitalKHRBalance: Double = 0.0
    

    
    // 當所有餘額計算完成時，用來通知的閉包
    var onTotalBalanceCalculated: ((Double) -> Void)?
    var onTotalKHRBalanceCalculated: ((Double) -> Void)?
    
    //方法：歸零所有帳戶餘額
    func resetAllBalances() {
        savingsUSDBalance = 0.0
        fixedDepositsUSDBalance = 0.0
        digitalUSDBalance = 0.0
        
        savingsKHRBalance = 0.0
        fixedDepositsKHRBalance = 0.0
        digitalKHRBalance = 0.0
    }
    

    
    // 方法：抓取所有儲蓄帳戶的資料（包含 USD 和 KHR）
    func fetchAllSavingsAccountData() {
        resetAllBalances()
        let url = "https://willywu0201.github.io/data/usdSavings1.json"
        fetchData(from: url) { (result: USDAmount?) in
            guard let savingsList = result?.result.savingsList else { return }
            
            // 逐筆檢查每個帳戶的資料
            for account in savingsList {
                print("儲蓄帳戶 - 帳戶號碼: \(account.account), 幣別: \(account.curr), 餘額: \(account.balance)")
                
                // 根據 curr 欄位來區分 USD 和 KHR 的餘額
                if account.curr == "USD" {
                    self.savingsUSDBalance += account.balance
                } else if account.curr == "KHR" {
                    self.savingsKHRBalance += account.balance
                } else {
                    print("未知的幣別：\(account.curr)，餘額未計入任何分類。")
                }
            }
            
            // 計算總餘額（USD 和 KHR 分別計算）
            self.calculateTotalBalance()
            self.calculateTotalKHRBalance()
        }
    }
    
    // 方法：抓取所有定期存款帳戶的資料（包含 USD 和 KHR）
    func fetchAllFixedAccountData() {
        resetAllBalances()
        let url = "https://willywu0201.github.io/data/usdFixed1.json"
        fetchData(from: url) { (result: FixedUSDAmount?) in
            guard let fixedList = result?.result.fixedDepositList else { return }
            
            // 逐筆檢查每個帳戶的資料
            for account in fixedList {
                print("定期存款帳戶 - 帳戶號碼: \(account.account), 幣別: \(account.curr), 餘額: \(account.balance)")
                
                // 根據 curr 欄位來區分 USD 和 KHR 的餘額
                if account.curr == "USD" {
                    self.fixedDepositsUSDBalance += account.balance
                } else if account.curr == "KHR" {
                    self.fixedDepositsKHRBalance += account.balance
                } else {
                    print("未知的幣別：\(account.curr)，餘額未計入任何分類。")
                }
            }
            
            // 計算總餘額（USD 和 KHR 分別計算）
            self.calculateTotalBalance()
            self.calculateTotalKHRBalance()
        }
    }
    
    // 方法：抓取所有數位帳戶的資料（包含 USD 和 KHR）
    func fetchAllDigitalAccountData() {
        resetAllBalances()
        let url = "https://willywu0201.github.io/data/usdDigital1.json"
        fetchData(from: url) { (result: DigitalUSDAmount?) in
            guard let digitalList = result?.result.digitalList else { return }
            
            // 逐筆檢查每個帳戶的資料
            for account in digitalList {
                print("數位帳戶 - 帳戶號碼: \(account.account), 幣別: \(account.curr), 餘額: \(account.balance)")
                
                // 根據 curr 欄位來區分 USD 和 KHR 的餘額
                if account.curr == "USD" {
                    self.digitalUSDBalance += account.balance
                } else if account.curr == "KHR" {
                    self.digitalKHRBalance += account.balance
                } else {
                    print("未知的幣別：\(account.curr)，餘額未計入任何分類。")
                }
            }
            
            // 計算總餘額（USD 和 KHR 分別計算）
            self.calculateTotalBalance()
            self.calculateTotalKHRBalance()
        }
    }
    
    // 方法：抓取USD儲蓄帳戶的資料
    func fetchReFreshUSDSavingsAccountData() {
        resetAllBalances()
        let url = "https://willywu0201.github.io/data/usdSavings2.json"
        fetchData(from: url) { (result: USDAmount?) in
            guard let savingsList = result?.result.savingsList else { return }
            
            // 逐筆檢查每個帳戶的資料
            for account in savingsList {
                print("儲蓄帳戶 - 帳戶號碼: \(account.account), 幣別: \(account.curr), 餘額: \(account.balance)")
                
                // 根據 curr 欄位來區分 USD 和 KHR 的餘額
                if account.curr == "USD" {
                    self.savingsUSDBalance += account.balance
                } else {
                    print("未知的幣別：\(account.curr)，餘額未計入任何分類。")
                }
            }
            
            // 計算總餘額（USD 和 KHR 分別計算）
            self.calculateTotalBalance()
            
        }
    }
    
    // 方法：抓取USD定期存款帳戶的資料
    func fetchReFreshUSDFixedAccountData() {
        resetAllBalances()
        let url = "https://willywu0201.github.io/data/usdFixed2.json"
        fetchData(from: url) { (result: FixedUSDAmount?) in
            guard let fixedList = result?.result.fixedDepositList else { return }
            
            // 逐筆檢查每個帳戶的資料
            for account in fixedList {
                print("定期存款帳戶 - 帳戶號碼: \(account.account), 幣別: \(account.curr), 餘額: \(account.balance)")
                
                // 根據 curr 欄位來區分 USD 和 KHR 的餘額
                if account.curr == "USD" {
                    self.fixedDepositsUSDBalance += account.balance
                } else {
                    print("未知的幣別：\(account.curr)，餘額未計入任何分類。")
                }
            }
            
            // 計算總餘額（USD 和 KHR 分別計算）
            self.calculateTotalBalance()
            
        }
    }
    
    // 方法：抓取USD數位帳戶的資料
    func fetchReFreshUSDDigitalAccountData() {
        resetAllBalances()
        let url = "https://willywu0201.github.io/data/usdDigital2.json"
        fetchData(from: url) { (result: DigitalUSDAmount?) in
            guard let digitalList = result?.result.digitalList else { return }
            
            // 逐筆檢查每個帳戶的資料
            for account in digitalList {
                print("數位帳戶 - 帳戶號碼: \(account.account), 幣別: \(account.curr), 餘額: \(account.balance)")
                
                // 根據 curr 欄位來區分 USD 和 KHR 的餘額
                if account.curr == "USD" {
                    self.digitalUSDBalance += account.balance
                } else {
                    print("未知的幣別：\(account.curr)，餘額未計入任何分類。")
                }
            }
            
            // 計算總餘額（USD 和 KHR 分別計算）
            self.calculateTotalBalance()
           
        }
    }
    
    // 方法：抓取KHR儲蓄帳戶的資料
    func fetchReFreshKHRSavingsAccountData() {
        resetAllBalances()
        let url = "https://willywu0201.github.io/data/khrSavings2.json"
        fetchData(from: url) { (result: USDAmount?) in
            guard let savingsList = result?.result.savingsList else { return }
            
            // 逐筆檢查每個帳戶的資料
            for account in savingsList {
                print("儲蓄帳戶 - 帳戶號碼: \(account.account), 幣別: \(account.curr), 餘額: \(account.balance)")
                
                // 根據 curr 欄位來區分 USD 和 KHR 的餘額
                if account.curr == "KHR" {
                    self.savingsKHRBalance += account.balance
                } else {
                    print("未知的幣別：\(account.curr)，餘額未計入任何分類。")
                }
            }
            
            // 計算總餘額（USD 和 KHR 分別計算）
            self.calculateTotalKHRBalance()
            
        }
    }
    
    // 方法：抓取KHR定期存款帳戶的資料
    func fetchReFreshKHRFixedAccountData() {
        resetAllBalances()
        let url = "https://willywu0201.github.io/data/khrFixed2.json"
        fetchData(from: url) { (result: FixedUSDAmount?) in
            guard let fixedList = result?.result.fixedDepositList else { return }
            
            // 逐筆檢查每個帳戶的資料
            for account in fixedList {
                print("定期存款帳戶 - 帳戶號碼: \(account.account), 幣別: \(account.curr), 餘額: \(account.balance)")
                
                // 根據 curr 欄位來區分 USD 和 KHR 的餘額
                if account.curr == "KHR" {
                    self.fixedDepositsKHRBalance += account.balance
                } else {
                    print("未知的幣別：\(account.curr)，餘額未計入任何分類。")
                }
            }
            
            // 計算總餘額（USD 和 KHR 分別計算）
            self.calculateTotalKHRBalance()
            
        }
    }
    
    // 方法：抓取KHR數位帳戶的資料
    func fetchReFreshKHRDigitalAccountData() {
        resetAllBalances()
        let url = "https://willywu0201.github.io/data/khrDigital2.json"
        fetchData(from: url) { (result: DigitalUSDAmount?) in
            guard let digitalList = result?.result.digitalList else { return }
            
            // 逐筆檢查每個帳戶的資料
            for account in digitalList {
                print("數位帳戶 - 帳戶號碼: \(account.account), 幣別: \(account.curr), 餘額: \(account.balance)")
                
                // 根據 curr 欄位來區分 USD 和 KHR 的餘額
                if account.curr == "KHR" {
                    self.digitalKHRBalance += account.balance
                } else {
                    print("未知的幣別：\(account.curr)，餘額未計入任何分類。")
                }
            }
            
            // 計算總餘額（USD 和 KHR 分別計算）
            self.calculateTotalKHRBalance()
           
        }
    }
    
    // 通用的資料抓取方法，將資料解析到指定的結構中
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
                print("JSON 解碼失敗：\(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    // 計算所有 USD 帳戶的總餘額
    private func calculateTotalBalance() {
        let totalBalance = savingsUSDBalance + fixedDepositsUSDBalance + digitalUSDBalance
        print("USD 帳戶總餘額: \(totalBalance)")
        onTotalBalanceCalculated?(totalBalance)
    }
    
    // 計算所有 KHR 帳戶的總餘額
    private func calculateTotalKHRBalance() {
        let totalKHRBalance = savingsKHRBalance + fixedDepositsKHRBalance + digitalKHRBalance
        print("KHR 帳戶總餘額: \(totalKHRBalance)")
        onTotalKHRBalanceCalculated?(totalKHRBalance)
    }
}


