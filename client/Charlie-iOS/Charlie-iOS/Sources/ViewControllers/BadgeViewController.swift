//
//  BadgeViewController.swift
//  Charlie-iOS
//
//  Created by ji Won Jeoung on 2022/07/23.
//

import Kingfisher
import SnapKit
import Then
import UIKit

class BadgeViewController: UIViewController {
    
    private var badgeList: [Badge] = []
    private var badgeCollectionView: BadgeCustomCollectionView!
    
    let titleLabel = UILabel().then {
        //$0.frame = CGRect(x: 0, y: 0, width: 160, height: 23)
        $0.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        //$0.layer.cornerRadius = 20
        $0.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        $0.font = UIFont.D2CodingBold(size: 20)
        $0.text = "Collected"
        $0.setLabelLineHeight(lineHeight: 22)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setupNavigationItem(self)
        
        getBadges()
        configureGridView()
        registerCollectionView()
        collectionViewDelegate()
        setupLayout()
    }
    
    private func configureGridView() {
        let collectionViewLayer = UICollectionViewFlowLayout()
        collectionViewLayer.minimumLineSpacing = 30
        collectionViewLayer.minimumInteritemSpacing = 30
        collectionViewLayer.itemSize = CGSize(width: 60, height: 60)
        
        badgeCollectionView = BadgeCustomCollectionView(frame: .zero, collectionViewLayout: collectionViewLayer).then {
            $0.backgroundColor = .white
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        }
        view.addSubview(badgeCollectionView)
        badgeCollectionView.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(70)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.right.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
    }
    
    private func collectionViewDelegate() {
        badgeCollectionView.delegate = self
        badgeCollectionView.dataSource = self
    }
    
    private func registerCollectionView() {
        badgeCollectionView.register(BadgeGridCollectionViewCell.self, forCellWithReuseIdentifier: BadgeGridCollectionViewCell.id)
    }
}

extension BadgeViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func setupLayout() {
        view.backgroundColor = UIColor(ciColor: .white)
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(23)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return badgeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BadgeGridCollectionViewCell.id, for: indexPath) as! BadgeGridCollectionViewCell
        let badgeData = badgeList[indexPath.row]
        let hasBadge:Bool = badgeData.acquired
        let badgeName:String = hasBadge ? badgeData.name : "gray"
        let url = URL(string: "https://charlie-storage.s3.ap-northeast-2.amazonaws.com/badges/\(badgeName).png")
        cell.badgeImage.kf.setImage(with: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBadge = badgeList[indexPath.row]
        let badgeVC = BadgeModalViewController()
        badgeVC.badgeName = selectedBadge.name
        badgeVC.hasBadge = selectedBadge.acquired
        badgeVC.badgeSteps = selectedBadge.steps
        badgeVC.badgeAwardedAt = selectedBadge.awardedAt
        presentPanModal(badgeVC)
    }
}

extension BadgeViewController {
    func getBadges() {
        BadgeAPI.shared.getUserBadges( completion: { [self] (response) in
            switch response {
            case .success(let data):
                if let data = data as? BadgesData {
                    self.badgeList = data.badges
                    self.badgeCollectionView.reloadData()
                }
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print(".pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        })
    }
}
