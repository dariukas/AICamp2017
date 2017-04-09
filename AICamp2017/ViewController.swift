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
    
    func run2() {
        
        let url = URL(fileURLWithPath: Bundle.main.resourcePath!+"/TrainingResult")
        print(url)
        
        let labeledImages = getImages(directoryName: "LbImages")
        let labeledModel = convertToColors(labeledImages, true)
        let restOfImages = getImages(directoryName: "ButterfliesImages")
        let restModel = convertToColors(restOfImages, false)
        
        let models = labeledModel+restModel
        
        print("Adding Data")
        var trainingData: [[Float]] = []
        var trainingLabels: [[Float]] = []
        for model in models {
            trainingData.append(model.0)
            if (model.1) {
                trainingLabels.append([1.0])
            } else {
                trainingLabels.append([0.0])
            }
        }
        print("Training Started")
        do {
            let structure = try NeuralNet.Structure(inputs: 1, hidden: 1, outputs: 1)
            let config = try NeuralNet.Configuration(activation: .sigmoid, learningRate: 0.5, momentum: 0.3)
            let nn = try NeuralNet(structure: structure, config: config)
            training(neuralNet: nn, trainingData: trainingData, labeledData: trainingLabels)
//            inferencing(neuralNet: nn)
        }
        catch let specialError as NSError {
            print(specialError.description)
        }

    }
    
    func createNeuralNet(inputsNumber: Int, outputsNumber: Int) -> NeuralNet? {
        var neuralNet: NeuralNet? = nil
        do {
            let hiddenInputsNumber = Int((inputsNumber * 2/3) + outputsNumber)
            let structure = try NeuralNet.Structure(inputs: inputsNumber, hidden: hiddenInputsNumber, outputs: outputsNumber)
            let config = try NeuralNet.Configuration(activation: .sigmoid, learningRate: 0.5, momentum: 0.3)
            neuralNet = try NeuralNet(structure: structure, config: config)
        }
        catch let specialError as NSError {
            print(specialError.description)
        }
        return neuralNet
    }
    
    func training(neuralNet: NeuralNet, trainingData: [[Float]], labeledData: [[Float]]) {
        do {
            let dataset = try NeuralNet.Dataset(trainInputs: trainingData, trainLabels: labeledData, validationInputs: trainingData, validationLabels: labeledData, structure: neuralNet.structure)
            let weigths = try neuralNet.train(dataset, cost: .crossEntropy, errorThreshold: 0.001)
            print("Result \(weigths)")
            print("Saving the weigths")
            try neuralNet.save(to: getStoreURL(filename: "TrainingResult.txt"))
        }
        catch let error as NSError  {
            print(error.description)
        }
    }
    
    func convertToColors(_ images: [String: UIImage], _ type: Bool) -> [([Float], Bool)] {
        var result: [([Float], Bool)] = []
        let ic = ImageColors()
        for image in images {
            //            let queue = DispatchQueue(label: "com.app.\(image.key)", attributes: .concurrent)
            //            queue.async {
            let colors: [Float] = ic.findColors()
            print("\(image.key) has: \(colors.count)")
            result.append((colors, type))
            //            }
        }
        return result
    }
    
    func getImages(directoryName: String) -> [String:UIImage] {
//        if let filePath = Bundle.main.path(forResource: "lbImages1", ofType: "jpeg", inDirectory: "LbImages") {
//            print(filePath)
//        }
//        let paths = Bundle.main.paths(forResourcesOfType: "jpeg", inDirectory: "LbImages")
        var images: [String:UIImage] = [:]
        if let resourcePath = Bundle.main.resourcePath {
            let fileManager = FileManager.default
            do {
                let paths = try fileManager.contentsOfDirectory(atPath: resourcePath+"/\(directoryName)")
                //print(fileManager.subpaths(atPath: resourcePath+"\\"+"LbImages") as Any)
                for path in paths {
                    let url = URL(fileURLWithPath: path)
                    if (url.pathExtension == "jpeg" || url.pathExtension == "png") {
                        if let image = UIImage(named: "\(directoryName)/\(path)") {
                            images.updateValue(image, forKey: path)
                            //                            images.append(image!)
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
        return images
    }
    //    func printDirectory() {
    //
//        let fileManager = FileManager.default
//        do {
//            let resourceKeys : [URLResourceKey] = [.creationDateKey, .isDirectoryKey]
//            let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//            let enumerator = FileManager.default.enumerator(at: documentsURL,
//                                                            includingPropertiesForKeys: resourceKeys,
//                                                            options: [.skipsHiddenFiles], errorHandler: { (url, error) -> Bool in
//                                                                print("directoryEnumerator error at \(url): ", error)
//                                                                return true
//            })!
//            
//            for case let fileURL as URL in enumerator {
//                let resourceValues = try fileURL.resourceValues(forKeys: Set(resourceKeys))
//                print(fileURL.path, resourceValues.creationDate!, resourceValues.isDirectory!)
//            }
//        } catch {
    //            print(error)
    //        }
    //    }
    
    
    func getStoreURL(filename: String) -> URL {
        let applicationDocumentsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let storePath: String = URL(fileURLWithPath: applicationDocumentsDir).appendingPathComponent(filename).absoluteString
        if let url = URL(string: storePath) {
            return url
        }
        return URL(fileURLWithPath: storePath)
    }
    
    //https://github.com/Swift-AI/Swift-AI/blob/master/Documentation/NeuralNet.md#multi-layer-feed-forward-neural-network
    func run() {
        do {
            if let nn: NeuralNet = createNeuralNet(inputsNumber: 2, outputsNumber: 1) {
                training(neuralNet: nn)
                try nn.save(to: getStoreURL(filename: "TrainingResult.txt"))
                //inferencing(neuralNet: nn)
            }
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
    
    //https://www.invasivecode.com/weblog/convolutional-neural-networks-ios-10-macos-sierra/?doing_wp_cron=1491647238.6945250034332275390625
    //https://github.com/Swift-AI/Swift-AI/blob/master/Documentation/NeuralNet.md#multi-layer-feed-forward-neural-network
    //https://blogs.nvidia.com/blog/2016/08/22/difference-deep-learning-training-inference-ai/
    func inferencing(neuralNet: NeuralNet) {
        let weights: [Float] =  [1.27217102, -2.62812805, -2.74673152, -2.59496784, 5.33755922, 5.21428537, 2.4808259, 4.77823496, -9.98672009]
        do{
            try neuralNet.setWeights(weights)
        }
        catch let error as NSError  {
            print(error.description)
        }
        
        let input: [Float] = [0.6, 0.0]
        do{
            let output = try neuralNet.infer(input)
            print(output)        }
        catch let error as NSError  {
            print(error.description)
        }
    }
}

