//
//  ViewController.swift
//  Sample-CSV
//
//  Created by 大西玲音 on 2021/10/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func generateCSVFile(_ sender: Any) {
        let fileName = "test.csv"
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                        .userDomainMask,
                                                                        true)[0]
        let documentURL = URL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(fileName)
        let output = OutputStream.toMemory()
        let csvWriter = CHCSVWriter(outputStream: output,
                                    encoding: String.Encoding.utf8.rawValue,
                                    delimiter: ",".utf16.first!)
        csvWriter?.writeField("No")
        csvWriter?.writeField("Name")
        csvWriter?.writeField("Age")
        csvWriter?.finishLine()
        
        var list = [[String]]()
        list.append(["111", "reon", "20"])
        list.append(["222", "tomoya", "54"])
        list.append(["333", "kenta", "16"])
        
        for elements in list.enumerated() {
            csvWriter?.writeField(elements.element[0])
            csvWriter?.writeField(elements.element[1])
            csvWriter?.writeField(elements.element[2])
            csvWriter?.finishLine()
        }
        
        csvWriter?.closeStream()
       
        let buffer = (output.property(forKey: .dataWrittenToMemoryStreamKey) as? Data)!
        
        do {
            try buffer.write(to: documentURL)
        } catch {
            print("DEBUG_PRINT: ", error.localizedDescription)
        }
    }
    
}

