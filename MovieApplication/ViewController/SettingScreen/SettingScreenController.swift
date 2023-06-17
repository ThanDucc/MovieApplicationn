//
//  SettingScreenController.swift
//  MovieApplication
//
//  Created by thanpd on 11/05/2023.
//

import UIKit

class SettingScreenController: UIViewController {

    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var tfSearchSetting: UITextField!
    @IBOutlet weak var enableNotiCheckbox: UIButton!
    @IBOutlet weak var sendUsageStatisticsCheckbox: UIButton!
    @IBOutlet weak var lbChooseTheme: UILabel!
    @IBOutlet weak var settingTheme: UIView!
    
    private var enableNoti = false {
        didSet {
            if enableNoti {
                enableNotiCheckbox.setBackgroundImage(UIImage(named: "checkbox_checked"), for: .normal)
            } else {
                enableNotiCheckbox.setBackgroundImage(UIImage(named: "checkbox_unchecked"), for: .normal)
            }
        }
    }
    
    private var sendUsasgeStatistics = false {
        didSet {
            if sendUsasgeStatistics {
                sendUsageStatisticsCheckbox.setBackgroundImage(UIImage(named: "checkbox_checked"), for: .normal)
            } else {
                sendUsageStatisticsCheckbox.setBackgroundImage(UIImage(named: "checkbox_unchecked"), for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        firstView.layer.cornerRadius = 15
        firstView.setBackground(tabbar: self.tabBarController!)
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.label,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light)
        ]
        tfSearchSetting.attributedPlaceholder = NSAttributedString(string: "Search in setting", attributes: attributes)
        settingTheme.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseThemeClicked(_:))))
        settingTheme.isUserInteractionEnabled = true
        
        btnMenu.setBackgroundImage(UIImage(named: "menu")?.withTintColor(.label), for: .normal)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationThemeChange), name: Notification.Name("Theme Changed"), object: nil)
    }
    
    @objc func notificationThemeChange() {
        firstView.setBackground(tabbar: self.tabBarController!)
    }
    
    @objc func chooseThemeClicked(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "SettingThemeView", bundle: nil)
        let settingThemeVC = storyboard.instantiateViewController(withIdentifier: "SettingThemeView") as! SettingThemeView
        settingThemeVC.modalPresentationStyle = .overFullScreen
        settingThemeVC.modalTransitionStyle = .crossDissolve
        self.parent!.present(settingThemeVC, animated: true)
    }

    @IBAction func btnEnableNotiClicked(_ sender: Any) {
        enableNoti = !enableNoti
    }
    
    @IBAction func btnSendUsageStatisticsClicked(_ sender: Any) {
        sendUsasgeStatistics = !sendUsasgeStatistics
    }
}
