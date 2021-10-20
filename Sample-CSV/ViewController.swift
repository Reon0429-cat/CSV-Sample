//
//  ViewController.swift
//  Sample-CSV
//
//  Created by 大西玲音 on 2021/10/21.
//

import UIKit
import UniformTypeIdentifiers

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func generateCSVFile(_ sender: Any) {
        // CSVファイル作成
        let output = OutputStream.toMemory()
        let csvWriter = CHCSVWriter(outputStream: output,
                                    encoding: String.Encoding.utf8.rawValue,
                                    delimiter: ",".utf16.first!)
        csvWriter?.writeField("No")
        csvWriter?.writeField("Name")
        csvWriter?.writeField("Age")
        csvWriter?.finishLine()
        
        let list: [[String]] = [
            ["111", "reon", "20"],
            ["222", "tomoya", "54"],
            ["333", "kenta", "16"]
        ]
        for elements in list {
            for index in 0..<elements.count {
                csvWriter?.writeField(elements[index])
            }
            csvWriter?.finishLine()
        }
        
        csvWriter?.closeStream()
        
        
        let fileName = "test.csv"
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                        .userDomainMask,
                                                                        true)[0]
        let documentURL = URL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(fileName)
        let buffer = (output.property(forKey: .dataWrittenToMemoryStreamKey) as? Data)!
        try! buffer.write(to: documentURL)
    }
    
    @IBAction func importCSV(_ sender: Any) {
        let supportedFiles: [UTType] = [.data]
        let documentPickerVC = UIDocumentPickerViewController(forOpeningContentTypes: supportedFiles,
                                                              asCopy: true)
        documentPickerVC.delegate = self
        documentPickerVC.allowsMultipleSelection = false
        present(documentPickerVC, animated: true)
    }
    
}

extension ViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController,
                        didPickDocumentsAt urls: [URL]) {
        let url = urls.first!
        let rows = NSArray(contentsOfCSVURL: url,
                           options: .sanitizesFields)!
        for row in rows {
            print("DEBUG_PRINT: ", row)
        }
    }
    
}
