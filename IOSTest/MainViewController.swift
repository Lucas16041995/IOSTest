//
//  MainViewController.swift
//  IOSTest
//
//  Created by chiaowei on 2024/10/8.
//

import UIKit

class MainViewController: UIViewController, UIScrollViewDelegate {
    
    let amountManager = AmountManager()
    
    let adBannerManager = ADBannerManager()
    
    let favoriteManager = FavoriteManager()
    
    var adImageURLs: [String] = []
    
    lazy var allTheScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    lazy var contenterView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "avatar")
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var bellButton: UIButton = {
        var button = UIButton()
        button = UIButton(type: .custom)
        button.setImage(UIImage(named: "iconBell01Nomal"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var myAccountBalanceLabel: UILabel = {
        let label = UILabel()
        label.text = "My Account Balance"
        label.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        label.textColor = UIColor(red: 136 / 255, green: 136 / 255, blue: 136 / 255, alpha: 1)
//        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var eyeButton: UIButton = {
        var button = UIButton()
        button = UIButton(type: .custom)
        button.setImage(UIImage(named: "iconEye01On"), for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var amountEyeBalanceStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [myAccountBalanceLabel, eyeButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var USDLabel: UILabel = {
        let label = UILabel()
        label.text = "USD"
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = UIColor(red: 85 / 255, green: 85 / 255, blue:  85 / 255, alpha: 1)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var USDView: CustomAmountView = {
        let view = CustomAmountView()
        view.frame = CGRect(x: 0, y: 0, width: 240, height: 32)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var KHRLabel: UILabel = {
        let label = UILabel()
        label.text = "KHR"
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = UIColor(red: 85 / 255, green: 85 / 255, blue:  85 / 255, alpha: 1)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var KHRView: CustomAmountView = {
        let view = CustomAmountView()
        view.frame = CGRect(x: 0, y: 0, width: 327, height: 32)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
       
    lazy var USDStack: UIStackView = {
    var stack = UIStackView(arrangedSubviews: [USDLabel, USDView])
    stack.axis = .vertical
    stack.alignment = .fill
    stack.distribution = .fillProportionally
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
}()
    
    lazy var KHRStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [KHRLabel, KHRView])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var meunButtons: [UIButton] = {
        let buttonImage = [UIImage(named: "button00ElementMenuTransfer"), UIImage(named: "button00ElementMenuPayment"), UIImage(named: "button00ElementMenuUtility"), UIImage(named: "button01Scan"), UIImage(named: "button00ElementMenuQRcode"), UIImage(named: "button00ElementMenuTopUp")]
        let buttonTitle = ["Transfer", "Payment", "Utility", "QR pay scan", "My QR code", "Top up"]
        
        var buttons = [UIButton]()
        
        for (index, image) in buttonImage.enumerated() {
            let button = UIButton(type: .system)
                
            // Configure the button
            var config = UIButton.Configuration.plain()
            config.image = image
            config.imagePlacement = .top // Set image position
            config.title = buttonTitle[index]
            config.titleAlignment = .center
            config.baseForegroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
                
            // Assign configuration to the button
            button.configuration = config
                
            // Additional button properties
            button.tag = index // Set tag if needed for identification
            button.translatesAutoresizingMaskIntoConstraints = false
                
            // Append the button to the array
            buttons.append(button)
        }
            
            return buttons
    }()
    
    lazy var meunStack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill // Center the rows
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var favoriteLabel: UILabel = {
        let label = UILabel()
        label.text = "My Favorite"
        label.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        label.textColor = UIColor(red: 136 / 255, green: 136 / 255, blue: 136 / 255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var moreLabel: UILabel = {
        let label = UILabel()
        label.text = "More"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(red: 85 / 255, green: 85 / 255, blue: 85 / 255, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    lazy var nextStepButton: UIButton = {
        var button = UIButton(type: .custom)
        button.setImage(UIImage(named: "iconArrow01Next"), for: .normal)
        return button
    }()
    
    lazy var moreNextStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [moreLabel, nextStepButton])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var scrollButton: UIButton = {
        var button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "button00ElementScrollEmpty")
        config.imagePlacement = .top // Set image position
        config.title = "---"
        config.titleAlignment = .center
        config.baseForegroundColor = UIColor(red: 111/255, green: 111/255, blue: 111/255, alpha: 1)
        button.configuration = config
        return button
    }()
    
    lazy var commitFavoriteLabel: UILabel = {
        let label = UILabel()
        label.text = "You can add a favorite through the transfer or payment function."
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(red: 111/255, green: 111/255, blue: 111/255, alpha: 1)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var commitFavoriteStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [scrollButton, commitFavoriteLabel])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var customTabBar: CustomTabBar = {
        let tabBar = CustomTabBar()
        tabBar.frame = CGRect(x: 0, y: 0, width: 327, height: 50)
//        tabBar.translatesAutoresizingMaskIntoConstraints = false
        return tabBar
    }()
    
    lazy var contentView: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var favoriteScrollView: UIScrollView = {
        let scroll = UIScrollView()
            scroll.isPagingEnabled = true // 啟用分頁效果
            scroll.showsHorizontalScrollIndicator = false
            scroll.showsVerticalScrollIndicator = false
            scroll.delegate = self // 設置代理
            scroll.translatesAutoresizingMaskIntoConstraints = false
            return scroll
    }()
    
    lazy var adScrollView: UIScrollView = {
        let scroll = UIScrollView()
            scroll.isPagingEnabled = true // 啟用分頁效果
            scroll.showsHorizontalScrollIndicator = false
            scroll.showsVerticalScrollIndicator = false
            scroll.delegate = self // 設置代理
            scroll.translatesAutoresizingMaskIntoConstraints = false
            return scroll
    }()
    
    lazy var adImageView: ADBannerImageView = {
        let image = ADBannerImageView(frame: CGRect(x: 0, y: 0, width: 327, height: 88))
        image.backgroundColor = UIColor(red: 220 / 255, green: 220 / 255, blue: 220 / 255, alpha: 0.5)
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var pageControl: UIPageControl = {
            let pageControl = UIPageControl()
            pageControl.currentPage = 0
            pageControl.numberOfPages = 0
            pageControl.pageIndicatorTintColor = .lightGray
            pageControl.currentPageIndicatorTintColor = .black
            pageControl.addTarget(self, action: #selector(pageControlTapped), for: .valueChanged)
            pageControl.translatesAutoresizingMaskIntoConstraints = false
            return pageControl
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .gray
        control.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return control
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMainPageView()
        

        
        fetchAmountData()
        
        
        amountManager.onTotalBalanceCalculated = { [weak self] totalBalance in
                   DispatchQueue.main.async {
                       self!.USDView.setAmount(String(format:"%.2f",totalBalance))
                   }
               }
        
        amountManager.onTotalKHRBalanceCalculated = { [weak self] totalKHRBalance in
            DispatchQueue.main.async {
                self!.KHRView.setAmount(String(format: "%.2f" ,totalKHRBalance))
            }
        }
               
        adBannerManager.onImageURL = { [weak self] imageURL in
                guard let self = self else { return }
                self.adImageURLs = imageURL // 儲存 URL 列表
                self.pageControl.numberOfPages = imageURL.count // 設置 PageControl 的頁數
                self.setupScrollView(with: imageURL) // 加入圖片到 ScrollView
            
        }
        
        favoriteManager.onTranType = { [weak self] tranType in
            guard let self = self else { return  }
            self.setupFavoriteScrollView(with: tranType)
        }
        
    }
    
    
    //設定畫面與auto layerout
    private func setMainPageView(){
        self.view.backgroundColor = UIColor(red: 250 / 255, green: 250 / 255, blue: 250 / 255, alpha: 1)
        
        self.view.addSubview(allTheScrollView)
        
        allTheScrollView.addSubview(contenterView)
    
        contenterView.addSubview(avatarImageView)
        
        contenterView.addSubview(bellButton)

        allTheScrollView.addSubview(amountEyeBalanceStack)
        
        allTheScrollView.addSubview(USDStack)
        
        allTheScrollView.addSubview(KHRStack)
        
        setupMenuStackView()
        
        allTheScrollView.addSubview(meunStack)
        
        allTheScrollView.addSubview(favoriteLabel)
        
        allTheScrollView.addSubview(moreNextStack)
        
        allTheScrollView.addSubview(favoriteScrollView)
        
        favoriteScrollView.addSubview(commitFavoriteStack)
        
        self.view.addSubview(contentView)
        
        contentView.addSubview(customTabBar)
        
        allTheScrollView.addSubview(adScrollView)
        
        adScrollView.addSubview(adImageView)
        
        allTheScrollView.addSubview(pageControl)
        
        allTheScrollView.refreshControl = refreshControl
        
        eyeButton.addTarget(self, action: #selector(tappedTheEyeButton), for: .touchUpInside)
        bellButton.addTarget(self, action: #selector(tappedTheNotificationBell), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            allTheScrollView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            allTheScrollView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            allTheScrollView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            allTheScrollView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
            
            contenterView.topAnchor.constraint(equalTo: allTheScrollView.topAnchor),
            contenterView.leadingAnchor.constraint(equalTo: allTheScrollView.leadingAnchor),
            contenterView.trailingAnchor.constraint(equalTo: allTheScrollView.trailingAnchor),
            contenterView.widthAnchor.constraint(equalTo: self.view.layoutMarginsGuide.widthAnchor),
            contenterView.heightAnchor.constraint(equalToConstant: 40),
            
            avatarImageView.topAnchor.constraint(equalTo: contenterView.topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: contenterView.leadingAnchor),
            
            bellButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            bellButton.trailingAnchor.constraint(equalTo: contenterView.trailingAnchor),
            
            amountEyeBalanceStack.leadingAnchor.constraint(equalTo: allTheScrollView.leadingAnchor),
            amountEyeBalanceStack.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16),
            
            USDView.widthAnchor.constraint(equalToConstant: 240),
            USDView.heightAnchor.constraint(equalToConstant: 32),
            
            KHRView.widthAnchor.constraint(equalToConstant: 327),
            KHRView.heightAnchor.constraint(equalToConstant: 32),
            
            USDStack.leadingAnchor.constraint(equalTo: allTheScrollView.leadingAnchor),
            USDStack.topAnchor.constraint(equalTo: amountEyeBalanceStack.bottomAnchor, constant: 12),
            USDStack.widthAnchor.constraint(equalToConstant: 240),
            
            KHRStack.leadingAnchor.constraint(equalTo: allTheScrollView.leadingAnchor),
            KHRStack.topAnchor.constraint(equalTo: USDStack.bottomAnchor, constant: 4),
            KHRStack.widthAnchor.constraint(equalToConstant: 327),
            
            meunStack.topAnchor.constraint(equalTo: KHRStack.bottomAnchor, constant: 12),
            meunStack.leadingAnchor.constraint(equalTo: allTheScrollView.leadingAnchor),
            meunStack.trailingAnchor.constraint(equalTo: allTheScrollView.trailingAnchor),
            
            favoriteLabel.leadingAnchor.constraint(equalTo: allTheScrollView.leadingAnchor),
            favoriteLabel.topAnchor.constraint(equalTo: meunStack.bottomAnchor, constant: 20),
            
            moreNextStack.trailingAnchor.constraint(equalTo: allTheScrollView.trailingAnchor),
            moreNextStack.centerYAnchor.constraint(equalTo: favoriteLabel.centerYAnchor),
            
            favoriteScrollView.topAnchor.constraint(equalTo: moreNextStack.bottomAnchor, constant: 16),
            favoriteScrollView.leadingAnchor.constraint(equalTo: allTheScrollView.leadingAnchor),
            favoriteScrollView.trailingAnchor.constraint(equalTo: allTheScrollView.trailingAnchor),
            favoriteScrollView.widthAnchor.constraint(equalTo: self.view.layoutMarginsGuide.widthAnchor),
            favoriteScrollView.heightAnchor.constraint(equalToConstant: 80),
            
            commitFavoriteStack.leadingAnchor.constraint(equalTo: favoriteScrollView.leadingAnchor),
            commitFavoriteStack.trailingAnchor.constraint(equalTo: favoriteScrollView.trailingAnchor),
            commitFavoriteStack.widthAnchor.constraint(equalTo: favoriteScrollView.widthAnchor),
            commitFavoriteStack.topAnchor.constraint(equalTo: moreNextStack.bottomAnchor, constant: 16),

                    
            contentView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -22),
            contentView.leadingAnchor.constraint(equalTo: allTheScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: allTheScrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: self.view.layoutMarginsGuide.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 50),
            
            customTabBar.heightAnchor.constraint(equalToConstant: 50),
            customTabBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            adScrollView.topAnchor.constraint(equalTo: favoriteScrollView.bottomAnchor, constant: 13),
            adScrollView.leadingAnchor.constraint(equalTo: allTheScrollView.leadingAnchor),
            adScrollView.trailingAnchor.constraint(equalTo: allTheScrollView.trailingAnchor),
            adScrollView.bottomAnchor.constraint(equalTo: allTheScrollView.bottomAnchor),
            adScrollView.widthAnchor.constraint(equalTo: self.view.layoutMarginsGuide.widthAnchor),
            adScrollView.heightAnchor.constraint(equalToConstant: 88),
            
            pageControl.topAnchor.constraint(equalTo: adScrollView.bottomAnchor, constant: 4),
            pageControl.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
//            pageControl.bottomAnchor.constraint(equalTo: allTheScrollView.bottomAnchor),
            
            adImageView.topAnchor.constraint(equalTo: adScrollView.topAnchor),
            adImageView.leadingAnchor.constraint(equalTo: adScrollView.leadingAnchor),
            adImageView.trailingAnchor.constraint(equalTo: adScrollView.trailingAnchor),
            adImageView.bottomAnchor.constraint(equalTo: adScrollView.bottomAnchor),
            adImageView.widthAnchor.constraint(equalTo: allTheScrollView.widthAnchor),
            adImageView.heightAnchor.constraint(equalToConstant: 88)

            
        ])
        
    }
    
    private func fetchAmountData() {
        amountManager.fetchAllSavingsAccountData()
        amountManager.fetchAllFixedAccountData()
        amountManager.fetchAllDigitalAccountData()
       
        
       }
    
    private func fetchADBannerData() {
        adBannerManager.fetchADBannerData()
    }
    
    private func fetchRefreshAmountData() {
        amountManager.fetchReFreshUSDSavingsAccountData()
        amountManager.fetchReFreshUSDFixedAccountData()
        amountManager.fetchReFreshUSDDigitalAccountData()
        
        amountManager.fetchReFreshKHRSavingsAccountData()
        amountManager.fetchReFreshKHRFixedAccountData()
        amountManager.fetchReFreshKHRDigitalAccountData()
    }
    
    private func fetchFavoriteData(){
        favoriteManager.fetchFavoriteData()
    }
    
    func setupMenuStackView() -> UIStackView {
        // Create a horizontal stack view for each group of three buttons
        var currentRowStackView = UIStackView()
        currentRowStackView.axis = .horizontal
        currentRowStackView.alignment = .fill
        currentRowStackView.distribution = .fillEqually
        currentRowStackView.translatesAutoresizingMaskIntoConstraints = false
        
        for (index, button) in meunButtons.enumerated() {
            if index % 3 == 0 && index != 0 {
                // Add the previous row to the main stack view
                meunStack.addArrangedSubview(currentRowStackView)
                
                // Create a new horizontal stack view for the next row
                currentRowStackView = UIStackView()
                currentRowStackView.axis = .horizontal
                currentRowStackView.spacing = 16
                currentRowStackView.alignment = .fill
                currentRowStackView.distribution = .fillEqually
            }
            
            currentRowStackView.addArrangedSubview(button)
        }
        
        // Add the last row to the main stack view
        meunStack.addArrangedSubview(currentRowStackView)
        
        return meunStack
    }
    
    private func setupScrollView(with urls: [String]) {
        // 移除 ScrollView 中所有子視圖，避免重複顯示
        adScrollView.subviews.forEach { $0.removeFromSuperview() }
        
        // 取得 ScrollView 的寬度與高度
        let scrollViewWidth = adScrollView.frame.width
        let scrollViewHeight = adScrollView.frame.height
        
        // 檢查 ScrollView 寬度是否有效，若無法取得則回傳
        guard scrollViewWidth > 0 else { return }
        
        // 設定 ScrollView 的 contentSize，讓其能夠容納所有圖片
        adScrollView.contentSize = CGSize(width: scrollViewWidth * CGFloat(urls.count), height: scrollViewHeight)
        
        // 動態加入每個廣告圖片
        for (index, url) in urls.enumerated() {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.loadImage(from: url) // 使用擴展的 loadImage 方法來加載圖片
            
            // 設置每個 ImageView 的 frame
            imageView.frame = CGRect(x: scrollViewWidth * CGFloat(index), y: 0, width: scrollViewWidth, height: scrollViewHeight)
            
            // 將每個 ImageView 加入到 ScrollView 中
            adScrollView.addSubview(imageView)
        }
        
        // 當 ScrollView 設置完成後，確保顯示第一張圖片
        adScrollView.contentOffset = .zero
    }
    
    private func setupFavoriteScrollView(with transTypes: [String]) {
        // 移除 ScrollView 中所有子視圖，避免重複顯示
        favoriteScrollView.subviews.forEach { $0.removeFromSuperview() }
        
        
        // 設定每個按鈕的寬度與 ScrollView 的高度
        let buttonWidth: CGFloat = 80 // 每個按鈕的固定寬度（可調整）
        let buttonHeight: CGFloat = 88
        
        
        // 設定 ScrollView 的 contentSize，讓其能夠容納所有按鈕
        favoriteScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(transTypes.count), height: buttonHeight)
        
        // 按鈕圖片陣列
        let favoriteButtonImage: [UIImage] = [
            UIImage(named: "button00ElementScrollTree")!,
            UIImage(named: "button00ElementScrollMobile")!,
            UIImage(named: "button00ElementScrollBuilding")!,
            UIImage(named: "button00ElementScrollCreditCard")!
        ]
        
        // 動態加入每個按鈕
        for (index, type) in transTypes.enumerated() {
            // 建立 UIButton
            let favoriteButton = UIButton(type: .custom)
            
            // 設置 UIButton.Configuration
            var configuration = UIButton.Configuration.plain()
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byTruncatingTail// 使用單詞換行
            paragraphStyle.alignment = .center
            
            configuration.image = favoriteButtonImage[index % favoriteButtonImage.count] // 按鈕圖像循環使用
            configuration.attributedTitle = AttributedString(type, attributes: AttributeContainer([
                .font: UIFont.systemFont(ofSize: 12, weight: .regular),
                .foregroundColor: UIColor(red: 111 / 255, green: 111 / 255, blue: 111 / 255, alpha: 1),
                .paragraphStyle: paragraphStyle
            ]))
            
            configuration.imagePlacement = .top // 圖片在上方
            
            // 套用 Configuration
            favoriteButton.configuration = configuration
            
            
            // 設置每個按鈕的 frame，按順序排列
            let xOffset = buttonWidth * CGFloat(index) // 按照每個按鈕的寬度排列
            favoriteButton.frame = CGRect(x: xOffset, y: 0, width: buttonWidth, height: buttonHeight)
                    
            // 為按鈕設置標籤（用於區分按鈕）
            favoriteButton.tag = index
                    
            // 將每個按鈕加入到 ScrollView 中
            favoriteScrollView.addSubview(favoriteButton)
        }
    }
    
    @objc func tappedTheEyeButton(_ sender: UIButton){
        sender.isSelected.toggle()
        
        if sender.isSelected {
            eyeButton.setImage(UIImage(named: "iconEye02Off"), for: .normal)
            USDView.isSecureTextEntry = true
            KHRView.isSecureTextEntry = true
        }else{
            eyeButton.setImage(UIImage(named: "iconEye01On"), for: .normal)
            USDView.isSecureTextEntry = false
            KHRView.isSecureTextEntry = false
        }
    }
    
    @objc func tappedTheNotificationBell(){
        let notificationVC = NotificationViewController()
        notificationVC.modalPresentationStyle = .fullScreen
        self.present(notificationVC, animated: true, completion: nil)
    }
    
    // 當 PageControl 被點擊時，更新 ScrollView 的位置
    @objc private func pageControlTapped(_ sender: UIPageControl) {
        // 根據 pageControl 當前頁面更新 ScrollView 的位置
        let currentPage = sender.currentPage
        let scrollPosition = CGFloat(currentPage) * adScrollView.frame.width
        adScrollView.setContentOffset(CGPoint(x: scrollPosition, y: 0), animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 當 ScrollView 滾動時，更新 PageControl 的當前頁面
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    @objc private func handleRefresh() {
        print("Refreshing amounts...")
        
               
        // Fetch the latest data when the user pulls to refresh
        fetchRefreshAmountData()
        
        fetchADBannerData()
        
        fetchFavoriteData()
               
        // End refreshing after a slight delay (or when network calls complete)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
        }
    }
   

}

import UIKit

extension UIImageView {
    // 擴展方法，用來從 URL 下載圖片並顯示
    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        // 設定佔位圖
        self.image = placeholder
        
        // 檢查 URL 是否有效
        guard let url = URL(string: urlString) else {
            print("無效的 URL：\(urlString)")
            return
        }
        
        // 使用 URLSession 來下載圖片
        URLSession.shared.dataTask(with: url) { data, response, error in
            // 處理錯誤
            if let error = error {
                print("圖片下載失敗：\(error.localizedDescription)")
                return
            }
            
            // 確認資料有效
            guard let data = data, let downloadedImage = UIImage(data: data) else {
                print("無法轉換圖片資料。")
                return
            }
            
            // 回到主線程更新 UI
            DispatchQueue.main.async {
                self.image = downloadedImage
            }
        }.resume()
    }
}

