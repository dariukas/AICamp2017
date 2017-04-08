//
//  ViewController.swift
//  AICamp2017
//
//  Created by Darius Miliauskas on 08/04/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func run() {
        do {
            let structure = try NeuralNet.Structure(inputs: 784, hidden: 420, outputs: 10)
            let config = try NeuralNet.Configuration(activation: .sigmoid, learningRate: 0.5, momentum: 0.3)
            let nn = try NeuralNet(structure: structure, config: config)
        }
        catch let specialError as NSError {
            print(specialError.description)
        }
    }
    
    func training() {
        let dataset = try NeuralNet.Dataset(trainInputs: myTrainingData,
                                            trainLabels: myTrainingLabels,
                                            validationInputs: myValidationData,
                                            validationLabels: myValidationLabels,
                                            structure: structure)
        
    }
    
}

