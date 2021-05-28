//
//  PopUpScreenViewController.swift
//  FinalProj
//
//  Created by Jacob Rosen on 4/3/21.
//

import UIKit

protocol PopUpViewControllerDelegate {
    func getSelectedUser(guest: Guest)
}


    class PopUpScreenViewController: UIViewController {

        var delegate: PopUpViewControllerDelegate? = nil
        var guests: [Guest] = []
        @IBOutlet weak var tableView: UITableView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            tableView.delegate = self
            tableView.dataSource = self
            
            
            let backgroundViewGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped(_:)))
            
           
            let width = UIScreen.main.bounds.size.width
            let height = UIScreen.main.bounds.size.height

            
            let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            backgroundView.addGestureRecognizer(backgroundViewGesture)
            
            
            self.view.addSubview(backgroundView)
            self.view.sendSubviewToBack(backgroundView)
        }

       
    
        @objc func backgroundViewTapped(_ sender: UITapGestureRecognizer!) {
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }

    extension PopUpScreenViewController: UITableViewDelegate, UITableViewDataSource {
        
        // Declare number of sections
        func numberOfSections(in tableView: UITableView) -> Int {
            
            return 1
        }
        
        // Declare number of rows in section
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return guests.count
        }

        // Customize cell
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "PopUpCell", for: indexPath) as! GuestsTableViewCell
            
           
            cell.name.text = guests[indexPath.row].name
            
            
            return cell
        }
        
   
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            
            self.delegate?.getSelectedUser(guest: guests[indexPath.row])
        
            self.dismiss(animated: true, completion: nil)
        }
    }
