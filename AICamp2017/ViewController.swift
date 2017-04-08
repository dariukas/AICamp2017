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
    
    
    //https://github.com/Swift-AI/Swift-AI/blob/master/Documentation/NeuralNet.md#multi-layer-feed-forward-neural-network
    func run() {
        do {
            let structure = try NeuralNet.Structure(inputs: 2, hidden: 2, outputs: 1)
            let config = try NeuralNet.Configuration(activation: .sigmoid, learningRate: 0.5, momentum: 0.3)
            let nn = try NeuralNet(structure: structure, config: config)
            //training(neuralNet: nn)
            inferencing(neuralNet: nn)
        }
        catch let specialError as NSError {
            print(specialError.description)
        }
    }
    
    func training(neuralNet: NeuralNet) {
        
        let myTrainingData: [[Float]] = [[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]]
        let myTrainingLabels: [[Float]] = [[1.0], [0.0], [0.0], [0.0]]
        let myValidationData = myTrainingData as [[Float]]
        let myValidationLabels = myTrainingLabels as [[Float]]
        
        do {
            let dataset = try NeuralNet.Dataset(trainInputs: myTrainingData, trainLabels: myTrainingLabels, validationInputs: myValidationData, validationLabels: myValidationLabels, structure: neuralNet.structure)
            let weigths = try neuralNet.train(dataset, cost: .crossEntropy, errorThreshold: 0.001)
            print("Result \(weigths)")
            //print(neuralNet.allWeights())
        }
        catch let error as NSError  {
            print(error.description)
        }
    }
    
    //https://blogs.nvidia.com/blog/2016/08/22/difference-deep-learning-training-inference-ai/
    func inferencing(neuralNet: NeuralNet) {
        let weights: [Float] =  [1.27217102, -2.62812805, -2.74673152, -2.59496784, 5.33755922, 5.21428537, 2.4808259, 4.77823496, -9.98672009]
        do{
            try neuralNet.setWeights(weights)
        }
        catch let error as NSError  {
            print(error.description)
        }
        
        let input: [Float] = [0.0, 0.0]
        do{
            let output = try neuralNet.infer(input)
            print(output)        }
        catch let error as NSError  {
            print(error.description)
        }
    }
}

