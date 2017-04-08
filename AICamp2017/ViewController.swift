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
        run()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func run() {
        do {
            let structure = try NeuralNet.Structure(inputs: 2, hidden: 2, outputs: 1)
            let config = try NeuralNet.Configuration(activation: .sigmoid, learningRate: 0.5, momentum: 0.3)
            let nn = try NeuralNet(structure: structure, config: config)
            training(neuralNet: nn)
        }
        catch let specialError as NSError {
            print(specialError.description)
        }
    }
    
    func training(neuralNet: NeuralNet) {

        let myTrainingData: [[Float]] = [[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]]
        let myTrainingLabels: [[Float]] = [[1.0, 1.0]]
        let myValidationData = myTrainingData as [[Float]]
        let myValidationLabels = myTrainingLabels as [[Float]]
        
        do {
            //let structure = try NeuralNet.Structure(inputs: 2, hidden: 2, outputs: 1)
            let dataset = try NeuralNet.Dataset(trainInputs: myTrainingData, trainLabels: myTrainingLabels, validationInputs: myValidationData, validationLabels: myValidationLabels, structure: neuralNet.structure)
            let weigths = try neuralNet.train(dataset, cost: .crossEntropy, errorThreshold: 0.001)
            print("Result \(weigths)")
            print(neuralNet.allWeights())
            
        }
        catch let error as NSError  {
            print(error)
        }
        
    }
    
}

