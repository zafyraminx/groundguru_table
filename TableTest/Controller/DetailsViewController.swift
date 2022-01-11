//
//  DetailsViewController.swift
//  TableTest
//
//  Created by Michael Angelo Zafra on 1/11/22.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var segueData: Animal? = nil
    
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var close: UIButton!
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = false
        self.title = segueData?.name
        self.imageView.image = UIImage(named: segueData?.name.lowercased() ?? "")
        self.detailLbl.text = segueData?.description
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: false)
    }
}
