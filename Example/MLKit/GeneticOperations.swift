//
//  GeneticOperations.swift
//  MLKit
//
//  Created by Guled  on 3/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import MachineLearningKit
import Upsurge


/// The GeneticOperations class manages encoding genes into weights for the neural network and decoding neural network weights into genes. These methods are not provided in the framework itself, rather it was for the game example.
final class GeneticOperations {


    /**
     The encode method converts a NueralNet object to an array of floats by taking the weights of each layer and placing them into an array.

     - parameter network: A NeuralNet Object.

     - returns: An array of Float values.
     */
    public static func encode(network: NeuralNet) -> [Float] {

        let inputLayerNuerons = network.inputLayer.listOfNeurons
        let hiddenLayerNeurons = network.listOfHiddenLayers[0].listOfNeurons
        let outputLayerNeurons = network.outputLayer.listOfNeurons

        var genotypeRepresentation: [Float] = []

        for neuron in inputLayerNuerons {
            genotypeRepresentation = genotypeRepresentation + neuron.weightsComingIn
        }

        for neuron in hiddenLayerNeurons {
            genotypeRepresentation = genotypeRepresentation + neuron.weightsComingIn
        }

        for neuron in hiddenLayerNeurons {
            genotypeRepresentation = genotypeRepresentation + neuron.weightsGoingOut
        }

        for neuron in outputLayerNeurons {
            genotypeRepresentation = genotypeRepresentation + neuron.weightsGoingOut
        }

        return genotypeRepresentation
    }


    /**
     The decode method converts a genotype back to a NeuralNet object by taking each value from the genotype and mapping them to a neuron in a particular layer.

     - parameter network: A NeuralNet Object.

     - returns: An array of Float values.
     */
    public static func decode(genotype: [Float]) -> NeuralNet {

        // Create a new NueralNet
        let brain = NeuralNet()

        brain.initializeNet(numberOfInputNeurons: 3, numberOfHiddenLayers: 1, numberOfNeuronsInHiddenLayer: 4, numberOfOutputNeurons: 1)

        brain.activationFuncType = .SIGLOG

        brain.activationFuncTypeOutputLayer = .SIGLOG

        // Convert genotype back to weights for each layer
        let inputLayerWeights: [Float] = Array<Float>(genotype[0...3])

        // First is bias neuron
        let hiddenLayerWeightsComingInForNueron1: [Float] = Array<Float>(genotype[4...7])
        let hiddenLayerWeightsComingInForNueron2: [Float] = Array<Float>(genotype[8...11])
        let hiddenLayerWeightsComingInForNueron3: [Float] = Array<Float>(genotype[12...15])
        let hiddenLayerWeightsComingInForNueron4: [Float] = Array<Float>(genotype[16...19])
        let hiddenLayerWeightsGoingOut: [Float] = Array<Float>(genotype[20...24])
        let outputLayerWeightGoingOut: Float = genotype[25]

        for (var i, var neuron) in brain.inputLayer.listOfNeurons.enumerated() {

            neuron.weightsComingIn = ValueArray<Float>([inputLayerWeights[i]])
        }

        for (var i, var neuron) in brain.listOfHiddenLayers[0].listOfNeurons.enumerated() {

            if i == 0 {
                continue
            } else if i == 1 {
                neuron.weightsComingIn = ValueArray<Float>(hiddenLayerWeightsComingInForNueron1)
            } else if i == 2 {
                neuron.weightsComingIn = ValueArray<Float>(hiddenLayerWeightsComingInForNueron2)
            } else if i == 3 {
                neuron.weightsComingIn = ValueArray<Float>(hiddenLayerWeightsComingInForNueron3)
            } else if i == 4 {
                neuron.weightsComingIn = ValueArray<Float>(hiddenLayerWeightsComingInForNueron4)
            }
        }

        for (var i, var neuron) in brain.listOfHiddenLayers[0].listOfNeurons.enumerated() {

            neuron.weightsGoingOut = ValueArray<Float>([hiddenLayerWeightsGoingOut[i]])

        }

        brain.outputLayer.listOfNeurons[0].weightsGoingOut = ValueArray<Float>([outputLayerWeightGoingOut])

        return brain
    }
}
