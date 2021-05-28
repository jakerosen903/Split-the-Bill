//
//  TableViewController.swift
//  FinalProj
//
//  Created by Caroline Carey on 4/2/21.
//

import UIKit

class AssignFoodTableViewController: UITableViewController, PopUpViewControllerDelegate {
    

    var selectedGuest: Guest? = nil
    var guests: [Guest?] =  []
    var foods: [Food] = []
    var check = 0
    

    

    @IBAction func addGuestImg(_ sender: UIButton) {
        view.endEditing(true)
        
        let alert = UIAlertController(title: "Enter Name", message: nil, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            
            let textField = alert?.textFields![0]
            
            if !(textField?.text?.isEmpty)! {
                
                let name = (textField?.text)!

                let first = String(name.prefix(1)).capitalized
                let other = String(name.dropFirst())
                
                let guest = Guest(name: first+other)
                
                self.guests.append(guest)
                
                self.selectedGuest = guest
                
                self.currentGuestLabel.text = "User : \(guest.name)"
                self.tableView.reloadData()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        present(alert, animated: true, completion: nil)

    }
    
    @IBOutlet weak var currentGuestLabel: UILabel!
    
    @IBOutlet weak var displayGuestsImg: UIImageView!
    @IBOutlet weak var taxText: UITextField!
    @IBOutlet weak var tipText: UITextField!
    @IBOutlet weak var optionView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        

        
    }
    
    /*
        -Purpose: Dimiss keyboard if it is up
    */
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    func getSelectedUser(guest: Guest) {
        
        selectedGuest = guest
        if let user = selectedGuest?.name {
            currentGuestLabel.text = "User: \(user)"
        }
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        
        let border = CALayer()
        border.backgroundColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: optionView.frame.height, width: optionView.frame.width, height: 1.5)
        optionView.layer.addSublayer(border)
    }
    
    /*
        Purpose: calculates everyone in people array owes
        -Tax and tip is dependent on user input
        -Adds two additional items for each Person: Tax, and Tip
    */
    private func calc() {
        
        print("hello")
        var tax: Float = 0
        var tip: Float = 0
        var totalTax: Float = 0
        var totalTip: Float = 0

        for food in foods {
            food.price = food.price / Float(food.guests.count)
        }
        
        for guest in guests {
            
            for food in (guest?.foods)! {
                
                tax += food.price * Float(taxText.text!)! / 100
                tip += food.price * Float(tipText.text!)! / 100
                
                totalTax += tax
                totalTip += tip
                
                guest?.owe += food.price + tax + tip
                
                tax = 0
                tip = 0
            }
            
            print(totalTax)
            print(totalTip)
            let taxFood = Food(name: "Tax", price: totalTax)
            let tipFood = Food(name: "Tip", price: totalTip)
            guest?.addFood(food: taxFood)
            guest?.addFood(food: tipFood)
            
            totalTax = 0
            totalTip = 0
            
        }
        check+=1
    }

    // MARK: Tap Gesture Recognizer
    /*
        -Purpose: Brings up an alert for User to add additional Person (placed in people array)
    
    @objc func addGuestImageTapped(_ sender: UITapGestureRecognizer) {
        
        
    }
    */
    /*
        -Purpose: handle tap gesture for when showPeopleImage is tapped
        -Instantiates the PopUpVC and uses delegate for that to pass back
        the user that is selected from the tableview to update the currentPerson
        variable
        -All these people are those who will be paying the bill
    */
    @IBAction func showGuestsImageTapped(_ sender: Any) {
        view.endEditing(true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popUpVC = storyboard.instantiateViewController(withIdentifier: "popUp") as! PopUpScreenViewController
        
        popUpVC.guests = guests as! [Guest]

        popUpVC.delegate = self
        
        popUpVC.modalPresentationStyle = .overCurrentContext
        popUpVC.modalTransitionStyle = .crossDissolve
        self.present(popUpVC, animated: true, completion: nil)
    }
    
    /*
        -Purpose: handle tap gesture of the peopleImage
        -Instantiates the PopUpVC to see Person who are paying
        for a specific item
    */
    @objc func guestsImageTapped(_ sender: UITapGestureRecognizer) {
        
        view.endEditing(true)

        let tapLocation = sender.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: tapLocation)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popUpVC = storyboard.instantiateViewController(withIdentifier: "popUp") as! PopUpScreenViewController
        
        popUpVC.guests = foods[(indexPath?.row)!].guests
        
        popUpVC.modalPresentationStyle = .overCurrentContext
        popUpVC.modalTransitionStyle = .crossDissolve
        self.present(popUpVC, animated: true, completion: nil)
        
    }

    // MARK: - Table view data source
    // Declare number of Sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    // Declare number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return foods.count
    }
    
    // Customize the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignCell", for: indexPath) as! FoodTableViewCell

        cell.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 0.10)
        

        cell.name.text = foods[indexPath.row].name
        let twoDecimalPlaces = String(format: "%.2f", foods[indexPath.row].price)
        cell.price.setTitle("$\(twoDecimalPlaces)", for: .normal)

        
        let guestsGesture = UITapGestureRecognizer(target: self, action: #selector(guestsImageTapped(_:)))
        cell.guests.addGestureRecognizer(guestsGesture)

        var foundGuest = false
        for guest in foods[indexPath.row].guests {
            
            if guest === selectedGuest {
                
                cell.name.textColor = UIColor(red: 0.0, green: 139.0/255.0, blue: 139.0/255.0, alpha: 1.0)
                cell.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 0.40)
                cell.name.font = UIFont.boldSystemFont(ofSize: 18.0)
                foundGuest = true
            }
        }
        
        if foundGuest == false {
            cell.backgroundColor = UIColor.white
            cell.name.font = UIFont.systemFont(ofSize: 17.0)
            cell.name.textColor = UIColor.black
        }

        return cell
    }
    
    // Handles action when row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        view.endEditing(true)
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if selectedGuest != nil {
            
            if cell?.backgroundColor == UIColor.white {
                
                selectedGuest?.addFood(food: foods[indexPath.row])
                foods[indexPath.row].addGuest(guest: selectedGuest!)
                tableView.reloadData()
            }
            else {
                
                selectedGuest?.removeFood(food: foods[indexPath.row])
                foods[indexPath.row].removeGuest(guest: selectedGuest!)
                tableView.reloadData()
            }
        }
    }
    
    /*
        -Purpose: Handles action when the Done UIBarButtonItem is tapped
    */
    @IBAction func showTotals(_ sender: UIBarButtonItem) {
        var flag1 = false
        var flag2 = false
        
        if let tax = Float(taxText.text!) {
            
            if tax >= 0.0 && tax <= 100.0 {
                flag1 = true
            }
        }
        
        if let tip = Float(tipText.text!) {
            
            if tip >= 0.0 && tip <= 100.0 {
                flag2 = true
            }
        }
        
        if flag1 && flag2 {
            performSegue(withIdentifier: "assignGuestsSegue", sender: nil)
        }

        if !flag1 {
            taxText.layer.cornerRadius = 5
            taxText.layer.borderWidth = 1.5
            taxText.layer.borderColor = UIColor.red.cgColor
        }
        if !flag2 {
            tipText.layer.cornerRadius = 5
            tipText.layer.borderWidth = 1.5
            tipText.layer.borderColor = UIColor.red.cgColor
        }
    }
   
        
     
    
    
    // Mark : Segue
    /*
        -Purpose: calculates the Bill for everyone in people array
        and pass that data onto the AssignPeopleVC
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        while check < 1 {
            if segue.identifier == "assignGuestsSegue" {
                
                if let assignGuestsVC = segue.destination as? AssignGuestsTableViewController {
                    calc()
                    assignGuestsVC.guests = guests
                    
                }
        
            }
        }
    }
}


