//
//  ViewController.swift
//  PracticeAndStudyUI
//
//  Created by app on 2022/05/19.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var table: UITableView!
    var list: [String] = []
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupList()
    }
    
    //MARK: Functions
    func setupList() {
        self.list.append("PageViewController in ContainerView")
    }
    func setupTable() {
        table.delegate = self
        table.dataSource = self
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainListCell.identifier) as! MainListCell
        
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.attributedText = AttrLogic.shared.getAttrsString(list[indexPath.row], elementsOfSourceText: .init(font: UIFont.systemFont(ofSize: 16, weight: .bold), foregroundColor: .black))
        
        cell.contentConfiguration = contentConfiguration
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "toPageVCInContainerViewController", sender: nil)
            break
        default: break
        }
    }
}
