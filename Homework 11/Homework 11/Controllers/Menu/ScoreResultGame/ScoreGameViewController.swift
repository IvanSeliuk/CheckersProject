//
//  ScoreGameViewController.swift
//  Homework 11
//
//  Created by Иван Селюк on 1.03.22.
//

import UIKit
import Lottie

enum LottieImage: String {
    case delete1, delete2, delete3
}

class ScoreGameViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var removeViewAnimate: AnimationView!
    
    var checkersDB = [Checkers]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableVeiw()
        setupUI()
        removeScore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        setupAnimation()
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
    
    func setupAnimation() {
        removeViewAnimate.animation = Animation.named(LottieImage.delete3.rawValue)
        removeViewAnimate.contentMode = .scaleAspectFit
        removeViewAnimate.loopMode = .loop
        removeViewAnimate.play()
    }
    
    private func getData() {
        let checkers = CoreDataManager.shared.getFromDB()
        checkersDB = checkers
        if checkersDB.count == 0 {
            removeViewAnimate.isHidden = true
        } else {
            removeViewAnimate.isHidden = false
        }
    }
    
    private func removeScore() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(removeViewAnimateTap))
        removeViewAnimate.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func removeViewAnimateTap() {
        CoreDataManager.shared.clearDataBase()
        checkersDB.removeAll()
        removeViewAnimate.isHidden = true
        tableView.reloadData()
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
        return checkersDB.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreResultGameTableViewCell") as? ScoreResultGameTableViewCell else { return UITableViewCell() }
        cell.setupCheckersCell(with: checkersDB[indexPath.row])
        cell.selectionStyle = .none
        return cell
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
