//
//  CarsViewController.swift
//  Carangas
//
//  Created by Denis Janoto on 26/03/2019.
//  Copyright © 2019 Denis Janoto. All rights reserved.
//

import UIKit
import WebKit
import Foundation

class CarsViewController: UIViewController {
    
    
    //CLASSE RESPONSÁVEL PELA VISUALIZAÇÃO DA IMAGEM DO CARRO NO APP E UTILIZADA PARA ACESSAR A VIEW DE EDIÇÃO DO CARRO
    
    
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var gas: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var car:Cars!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        brand.text = car.brand
        gas.text = car.gas
        value.text = "\(car.price)"
        title = car.name
        
        
        //WETKIT - VIZUALIZADOR DE UMA PÁGINA DA WEB DENTRO DO APP
        //Substitui espaços em brancos pelo sinal de +(para buscar no google)
        let name = (title! + "+" + car.brand).replacingOccurrences(of: " ", with: "+")
        let urlString = "https://www.google.com/search?q=\(name)&tbm=isch"
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        
        
        webView.allowsBackForwardNavigationGestures = true //Navegado com touch
        webView.allowsLinkPreview = true //Visuzlizar links apertando com mais força na foto
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.load(request)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddEditViewController
        vc.car = car
    }
    
}

extension CarsViewController:WKNavigationDelegate,WKUIDelegate{
    
    //METODO CHAMADO SEMPRE QUE A PÁGINA TERMINAR DE CARREGAR
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loading.stopAnimating()
    }
    
}
