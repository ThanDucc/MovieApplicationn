//
//  SettingThemeView.swift
//  Movie Application
//
//  Created by ThanDuc on 26/05/2023.
//

import UIKit

class SettingThemeView: UIViewController {

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var customView: UIView!
    @IBOutlet var radioButtonThemes: [UIButton]?
    var idx = 0
    var radioButtonIndex = UserDefaults.standard.integer(forKey: "radioButtonIndex") {
        didSet {
            radioButtonThemes![radioButtonIndex].setBackgroundImage(UIImage(named: "radiobutton_checked")?.withTintColor(.label), for: .normal)
            radioButtonThemes![oldValue].setBackgroundImage(UIImage(named: "radiobutton_unchecked")?.withTintColor(.label), for: .normal)
            idx = radioButtonIndex
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        customView.layer.cornerRadius = 8
        for button in radioButtonThemes! {
            button.setBackgroundImage(UIImage(named: "radiobutton_unchecked")?.withTintColor(.label), for: .normal)
        }
        radioButtonThemes![radioButtonIndex].setBackgroundImage(UIImage(named: "radiobutton_checked")?.withTintColor(.label), for: .normal)
        parentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView(_:))))
    }
    
    @objc func dismissView(_ gesture: UITapGestureRecognizer) {
        dismissView()
    }
    
    func setup() {
        let tabBarController = MainScreenController.tabbar
        if tabBarController!.overrideUserInterfaceStyle == .dark {
            self.overrideUserInterfaceStyle = .dark
            customView.backgroundColor = #colorLiteral(red: 0.1036594953, green: 0.09714179896, blue: 0.1189824288, alpha: 1)
        } else if tabBarController?.overrideUserInterfaceStyle == .light {
            self.overrideUserInterfaceStyle = .light
            customView.backgroundColor = #colorLiteral(red: 0.9487966895, green: 0.9302164316, blue: 0.966432631, alpha: 1)
        }
    }
    
    @IBAction func btnRadioButtonClicked(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            break
        case 1:
            UserDefaults.standard.setValue("dark", forKey: "ThemeApp")
            MainScreenController.tabbar!.overrideUserInterfaceStyle = .dark
            break
        case 2:
            UserDefaults.standard.setValue("light", forKey: "ThemeApp")
            MainScreenController.tabbar!.overrideUserInterfaceStyle = .light
            break
        default: break
        }
        
        setup()
        
        MainScreenController.tabbar?.viewDidLoad()
        NotificationCenter.default.post(name: Notification.Name("Theme Changed"), object: nil)
        
        if radioButtonIndex != sender.tag {
            radioButtonIndex = sender.tag
        }
    }
    
    @IBAction func btnConfirmClicked(_ sender: Any) {
        dismissView()
    }
    
    func dismissView() {
        self.dismiss(animated: true)
        UserDefaults.standard.setValue(idx, forKey: "radioButtonIndex")
    }
}
