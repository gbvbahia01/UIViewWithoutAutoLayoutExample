//
//  FirstViewController.swift
//  ConstraintsInCode
//
//  Created by Guilherme B V Bahia on 19/05/20.
//  Copyright © 2020 Guilherme B V Bahia. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var boxView: BoxInfoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boxView.addLabels(at: 0, titlesValues: ["Label 1-1", "Value1",
                                                "Label 1-3", "Value3"])
        
        boxView.addLabels(at: 1, titlesValues: ["Label 2-1", "Value4",
                                                "Label 2-3", "Value6"])
        
        boxView.addLabels(at: 2, titlesValues: ["Label 3-1", "Value7",
                                                "Label 3-3", "Value9"])
        
        boxView.addLabels(at: 3, titlesValues: ["Label 4-1", "Value10",
                                                "Label 4-2", "Value11",
                                                "Label 4-3", "Value12"])
        
        boxView.updateBox()
    }


}

