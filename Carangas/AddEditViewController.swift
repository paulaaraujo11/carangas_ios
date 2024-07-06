//
//  AddEditViewController.swift
//  Carangas
//
//  Created by Denis Janoto on 26/03/2019.
//  Copyright © 2019 Denis Janoto. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {
    
    //CLASSE RESPONSÁVEL PELO CADASTRO DE NOVO CARRO/INSERÇÃO DE NOVAS INFORMAÇÕES(EDIÇÃO)
    
    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var sgGasType: UISegmentedControl!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var car:Cars!
    var brands:[Brand] = []
    
    lazy var pickerView:UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if car != nil{
            tfBrand.text = car.brand
            tfBrand.text = car.brand
            tfPrice.text = "\(car.price)"
            sgGasType.selectedSegmentIndex = car.gasType
            btAddEdit.setTitle("Alterar Carro", for: .normal)
   
            
            loadBrands()
            
        }
        
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        toolbar.tintColor = UIColor(named: "myColor")
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:#selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:#selector(done))
        toolbar.items = [btCancel,btSpace,btDone]
        tfBrand.inputAccessoryView = toolbar
        
        tfBrand.inputView = pickerView
    }
    
    
    //CHAMA O METODO loadMarcas na classe rest()
    func loadBrands(){
        Rest.loadMarcas { (brands) in
            if let brands = brands{
                //Ordena os valores - Ordem Alfabética
                self.brands = brands.sorted(by: {$0.fipe_name < $1.fipe_name})
                DispatchQueue.main.async {
                    self.pickerView.reloadAllComponents()
                }
                
            }
        }
    }
    
    @objc func cancel(){
        tfBrand.resignFirstResponder()
    }
    
    @objc func done(){
        tfBrand.text = brands[pickerView.selectedRow(inComponent: 0)].fipe_name
        cancel()
    }
    
    

    
    @IBAction func addEdit(_ sender: UIButton) {
        //Altera o botão cadastrar
        sender.backgroundColor = .gray
        sender.alpha = 0.5
        sender.isEnabled = false
        
        //Starta a animação loading
        loading.startAnimating()
        
        if car == nil{
            car = Cars()
        }
        car.name = tfName.text!
        car.brand = tfBrand.text!
        if (tfPrice.text?.isEmpty)!{
            tfPrice.text="0"
        }
        car.price = Double(tfPrice.text!)!
        car.gasType = sgGasType.selectedSegmentIndex
        
        //SE ID FOR NIL, SIGNIFICA QUE NÃO HÁ NENHUM CARRO CADASTRADO
        if car._id == nil{
            Rest.saveCar(car: car) { (success) in
                self.goBack()
            }
            //SE ID FOR DIFERENTE DE NIL, SIGNIFICA QUE JÁ EXISTE CARRO CADASTRADO, QUERO ALTERAR
        }else{
            Rest.updateCar(car: car) { (success) in
                self.goBack()
            }
        }
        
        
    }
    
    func goBack(){
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
}

extension AddEditViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    
    //MÉTODOS OBRIGATORIOS PARA A CONTRUÇÃO DA PICKERVIEW
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return brands.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let brand = brands[row]
        return brand.fipe_name
    }
    
    
}
