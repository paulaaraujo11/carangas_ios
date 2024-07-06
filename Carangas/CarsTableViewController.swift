//
//  CarsTableViewController.swift
//  Carangas
//
//  Created by Denis Janoto on 26/03/2019.
//  Copyright © 2019 Denis Janoto. All rights reserved.
//

import UIKit

class CarsTableViewController: UITableViewController {
    
    //CLASSE DA TELA PRINCIPAL, MOSTRA OS CARROS CONSUMIDOS DA API
    
    var cars:[Cars]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Carregando Carros"
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSegue"{
            let vc = segue.destination as! CarsViewController
            vc.car = cars[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    //CRIAÇÃO DA LABEL (Não existem carros cadastrados)
    lazy var label:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "myColor")
        
        return label
        
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        Rest.loadCars(onComplete: { (cars) in
            self.cars = cars
            //Como o dataTask na classe Rest() é executado em outra thread, é preciso executar o reloadData na main thread, senão os dados não irão aparecer na tabela
            DispatchQueue.main.async {
                self.label.text = "Não existe carros cadastrados"
                self.tableView.reloadData()
            }
            
        }) { (error) in
            print(error)
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        tableView.backgroundView = cars.count == 0 ? label:nil
        return cars.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let car = cars[indexPath.row]
        cell.textLabel?.text = car.name
        cell.detailTextLabel?.text = car.brand
        
        return cell
    }
    
    //DELETA UM CARRO NA TABLEVIEW E CHAMA O METODO DELETE NA CLASSE REST
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let car = cars[indexPath.row]
            Rest.deleteCar(car: car) { (success) in
                if success{
                    self.cars.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
    }
}
