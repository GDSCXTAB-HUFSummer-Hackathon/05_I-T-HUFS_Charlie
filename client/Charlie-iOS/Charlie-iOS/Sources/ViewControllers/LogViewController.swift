//
//  LogViewController.swift
//  Charlie-iOS
//
//  Created by Hyowon Jeon on 2022/07/23.
//

import SnapKit
import Then
import UIKit

class LogViewController: UIViewController {
    
    private var logList: [Log] = []
    
    private lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.separatorStyle = .none
        $0.sectionFooterHeight = 12
        $0.backgroundColor = .white
        $0.allowsSelection = false
        $0.dataSource = self
        $0.delegate = self
        $0.register(LogTableViewCell.self, forCellReuseIdentifier: LogTableViewCell.identifier)
    }
    
    let pastWalksLabel = UILabel().then {
        $0.text = "Past Walks"
        $0.font = UIFont.D2CodingBold(size: 20)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        getUserLog()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        navigationController?.setupNavigationItem(self)
        
        setupLayout()
    }
    
}

extension LogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
}

extension LogViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        logList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LogTableViewCell.identifier,
            for: indexPath
        ) as? LogTableViewCell else { return UITableViewCell() }
        
        let steps = Formatter().numberFormatter(number: logList[indexPath.section].steps)
        let date = logList[indexPath.section].date
        cell.setupView(steps: steps, date: date)
        return cell
    }
}

private extension LogViewController {

    func setupLayout() {
        [
            pastWalksLabel,
            tableView
        ].forEach { view.addSubview($0) }
                
        pastWalksLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(23)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(pastWalksLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension LogViewController {
    func getUserLog() {
        LogAPI.shared.getUserLog(completion: { (response) in
            switch response {
            case .success(let data):
                if let data = data as? LogsData {
                    self.logList = data.logs
                    self.tableView.reloadData()
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
