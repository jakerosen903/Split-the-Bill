//
//  PriceTableViewController.swift
//  FinalProj
//
//  Created by Jason Talpalar on 4/14/21.
//

import UIKit
import TesseractOCR

class PriceTableViewController: UITableViewController {

    var foods: [Food] = []
    var passedImage: UIImage? = nil
    
    @IBOutlet weak var processedImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // The image is passed and loaded here
        processedImageView.image = passedImage
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    // Returns number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return foods.count
    }
    
    // Determine the height of each cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 85
    }

    // Creates the Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "PriceCell", for: indexPath) as! FoodTableViewCell
        
        // Create slight gray background
        cell.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 0.15)
        
        // Creates the color and border for the Price button
        cell.price.layer.borderWidth = 1
        cell.price.layer.borderColor = UIColor.green.cgColor
        
        // Creates the color and border for Delete button
        cell.deleteButton.layer.borderWidth = 1
        cell.deleteButton.layer.borderColor = UIColor.red.cgColor
        
        // Set tags for NameLabel, PriceButton, and DeleteButton
        // This way they can be referred to when a tapGesture is
        // placed on them
        cell.name.tag = indexPath.row
        cell.price.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        cell.name.text = foods[indexPath.row].name
        
        let twoDecimalPlaces = String(format: "%.2f", foods[indexPath.row].price)
        cell.price.setTitle("$\(twoDecimalPlaces)", for: .normal)
        
        // Attach double tap gesture so that the user can change the name
        // of the nameLabel
        let nameChangeGesture = UITapGestureRecognizer(target: self, action: #selector(nameChange(_:)))
        nameChangeGesture.numberOfTapsRequired = 2
        cell.name.addGestureRecognizer(nameChangeGesture)
        
        // Add target to the priceButton so that its price can be changed
        cell.price.addTarget(self, action: #selector(priceButtonTapped), for: .touchUpInside)
        
        // Add target to the deleteButton so that the row can be deleted when tapped
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        // Return cell
        return cell
    }
    
    /*
        -This function serves the purpose of handling action when the price button is tapped
        -Brings up an alert for user to manually enter price of the food
    */
    @objc func priceButtonTapped(sender: UIButton!) {
        
        // Create the alert controller.
        let alert = UIAlertController(title: "Enter Price", message: nil, preferredStyle: .alert)
        
        // Add the text field
        alert.addTextField { (textField) in
            textField.keyboardType = .decimalPad
        }
        
        // Grab the value from the text field,
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            
            if !(textField?.text?.isEmpty)! {
                
                self.foods[sender.tag].price = Float((textField?.text)!)!
                self.tableView.reloadData()
            }
        }))
        
        // Add cancel button
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    /*
        -This function serves the purpose of handling when the delete button is pressed
        -The tableview will animate the removal of the food and the food itself will
        be removed from the foods array
    */
    @objc func deleteButtonTapped(sender: UIButton!) {
        
        tableView.reloadData()
        foods.remove(at: sender.tag)
        tableView.deleteRows(at: [IndexPath(row: sender.tag, section: 0)], with: .left)
    }
    
    /*
        -This function serves the purpose of handling when the label is double tapped
        -It will bring up an alert for the user to manually input the name to change
        it to
    */
    @objc func nameChange(_ sender: UITapGestureRecognizer) {
        
        // Create the alert controller.
        let alert = UIAlertController(title: "Enter Food Name", message: nil, preferredStyle: .alert)
        
        // Add text field
        alert.addTextField(configurationHandler: nil)
        
        // Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            
            if !(textField?.text?.isEmpty)! {
                self.foods[(sender.view?.tag)!].name = (textField?.text)!
                self.tableView.reloadData()
            }
        }))
        
        // Add cancel button
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    /*
        -This function serves the purpose of when the UIBarButtonFood is pressed
        -It performs the segue to the AssignFood Scene
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "assignSegue", sender: nil)
    }
    */
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "assignSegue", sender: nil)
        
    }
    // MARK: Segue
    /*
        -This function serves the purpose to passing the foods array
        into the next AssignFoodTVC
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "assignSegue" {
            if let assignVC = segue.destination as? AssignFoodTableViewController {
                assignVC.foods = foods
            }
        }
    }
}
