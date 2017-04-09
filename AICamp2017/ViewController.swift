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
        run2()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func run2() {
        let labeledImages = getImages(directoryName: "LbImages")
        let labeledModel = convertToColors(labeledImages, true)
        let restOfImages = getImages(directoryName: "ButterfliesImages")
        let restModel = convertToColors(restOfImages, false)
        
        let models = labeledModel+restModel
        
        print("Adding Data")
        var trainingData: [[Float]] = []
        var trainingLabels: [[Float]] = []
        for model in models {
            trainingData.append(model.0 as! [Float])
            if (model.1) {
                trainingLabels.append([1.0])
            } else {
                trainingLabels.append([0.0])
            }
        }
        print("Training Started")
    }

    
    func convertToColors(_ images: [String: UIImage], _ type: Bool) -> [([[Float]], Bool)] {
        var result: [([[Float]], Bool)] = []
        let ic = ImageColors()
        for image in images {
            //            let queue = DispatchQueue(label: "com.app.\(image.key)")
            //            queue.async {
            let colors: [[Float]] = ic.convertToColors(cgImage: ic.cgImageFromUIImage(image.value)!)
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
        
        let input: [Float] = [0.6, 0.0]
        do{
            let output = try neuralNet.infer(input)
            print(output)        }
        catch let error as NSError  {
            print(error.description)
        }
    }
}

