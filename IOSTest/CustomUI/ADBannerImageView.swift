//
//  ADBannerImageView.swift
//  IOSTest
//
//  Created by chiaowei on 2024/10/10.
//

import UIKit

class ADBannerImageView: UIImageView {
    
    lazy var labelBackground: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 48, height: 24)
        view.backgroundColor = UIColor(red: 190 / 255, green:  190 / 255, blue: 190 / 255, alpha: 1)
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var adView: UILabel = {
        let label = UILabel()
        label.text = "AD"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImageView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setImageView(){
        self.addSubview(labelBackground)
        
        labelBackground.addSubview(adView)
        
        NSLayoutConstraint.activate([
            labelBackground.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            labelBackground.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            labelBackground.widthAnchor.constraint(equalToConstant: 48),
            labelBackground.heightAnchor.constraint(equalToConstant: 24),
            
            adView.centerXAnchor.constraint(equalTo: labelBackground.centerXAnchor),
            adView.centerYAnchor.constraint(equalTo: labelBackground.centerYAnchor),
        ])
    }
    
    func showADView(_ hidden: Bool){
        labelBackground.isHidden = hidden
        adView.isHidden = hidden
    }

}
