//
//  DemoSheetViewController.swift
//  STIBottomSheet
//
//  Created by Sven Titgemeyer on 28.07.18.
//  Copyright © 2018 Sven Titgemeyer. All rights reserved.
//

import UIKit

class DemoSheetViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "identifier")
        self.tableView.backgroundColor = .clear
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100;
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.text = indexPath.description
        return cell
    }
}
