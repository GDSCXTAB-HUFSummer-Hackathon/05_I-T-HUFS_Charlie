//
//  UINavigationController+Extension.swift
//  Charlie-iOS
//
//  Created by Hyowon Jeon on 2022/07/23.
//

import UIKit
import Then

extension UINavigationController {

    func setupNavigationItem(_ target: UIViewController) {
                
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationBarAppearance.setBackIndicatorImage(UIImage(named: "white"), transitionMaskImage: UIImage(named: "white"))
        target.navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        target.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance

        let backButtonTitle = "<- BACK"
        let attributes: [NSAttributedString.Key : AnyObject] = [.font : UIFont.D2Coding(size: 16)]
        let backButton = UIBarButtonItem(title: backButtonTitle, style: .plain, target: self, action: nil)
        backButton.setTitleTextAttributes(attributes, for: .normal)
        backButton.setTitleTextAttributes(attributes, for: .highlighted)
        target.navigationItem.backBarButtonItem = backButton
        target.navigationItem.backBarButtonItem?.tintColor = .black
    }

}
