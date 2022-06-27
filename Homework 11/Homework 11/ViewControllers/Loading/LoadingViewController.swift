//
//  LoadingViewController.swift
//  Homework 11
//
//  Created by Иван Селюк on 7.02.22.
//

import UIKit

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var loadingImage: UIImageView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    //MARK: - Life cicle VC
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
    }
}
