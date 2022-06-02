//
//  ScoreGameViewController.swift
//  Homework 11
//
//  Created by Иван Селюк on 1.03.22.
//

import UIKit

class ScoreGameViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableVeiw()
        setupUI()
    }
    
    private func setupUI() {
        backButton.setTitle("BACK".localized, for: .normal)
        backButton.setTitle("BACK".localized, for: .disabled)
    }
    
    private func setupTableVeiw() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ScoreResultGameTableViewCell", bundle: nil), forCellReuseIdentifier: "ScoreResultGameTableViewCell")
    }
    
    @IBAction func backToMenuButton(_ sender: Any) {
        guard let menuVC = MenuViewController.getInstanceController else { return }
        menuVC.modalPresentationStyle = .fullScreen
        menuVC.modalTransitionStyle = .crossDissolve
        self.present(menuVC, animated: true, completion: nil)
    }
}

extension ScoreGameViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: let cell = UITableViewCell()
            cell.backgroundColor = .clear
            return cell
        case 1: guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreResultGameTableViewCell") as? ScoreResultGameTableViewCell else { return UITableViewCell() }
            return cell
        default: return UITableViewCell()
        }
    }
}

extension ScoreGameViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 198
    }
}
