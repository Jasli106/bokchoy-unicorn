//
//  LegalDocsVC.swift
//  bokchoy-unicorn_project
//
//  Created by Verdande on 7/29/19.
//  Copyright © 2019 Jasmine Li. All rights reserved.
//

import UIKit
import PDFKit

class LegalDocsVC: UIViewController {
    
    @IBOutlet var pdfView: PDFView!
    
    public var file = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = Bundle.main.path(forResource: file, ofType: "pdf") {
            if let pdfDocument = PDFDocument(url: URL(fileURLWithPath: path)) {
                pdfView.displayMode = .singlePageContinuous
                pdfView.autoScales = true
                pdfView.displayDirection = .vertical
                pdfView.document = pdfDocument
            }
        }
        
    }
    
    @IBAction func closeDoc(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
