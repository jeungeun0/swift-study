//
//  PageVCInContainerViewController.swift
//  PracticeAndStudyUI
//
//  Created by app on 2022/05/19.
//

import UIKit

class PageVCInContainerViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var collectionView: UICollectionView!
    
    var list: [String] = []
    
    var currentIndex: Int = 0 {
        didSet{
            print("currentIndex: \(currentIndex)")
            
            let cell = collectionView.cellForItem(at: IndexPath(row: currentIndex, section: 0)) as! CategoryCollectionViewCell
            cell.titleLabel.textColor = .orange
            
            if let previousIndex = self.previousIndex {
                let prevCell = collectionView.cellForItem(at: IndexPath(row: previousIndex, section: 0)) as! CategoryCollectionViewCell
                prevCell.titleLabel.textColor = .black
            }
        }
    }
    
    var previousIndex: Int? = nil {
        didSet{
            print("previousIndex: \(String(describing: previousIndex))")
        }
    }
    
    var pageViewController: PageViewController!
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCollectionView()
        setupList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPageVC" {
            print("Connected")
            guard let vc = segue.destination as? PageViewController else { return }
            pageViewController = vc
            pageViewController?.completeHandler = { (result) in
                self.previousIndex = self.currentIndex
                self.currentIndex = result
            }
        }
    }
    
    //MARK: Functions
    func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.showsHorizontalScrollIndicator = false
        
        
        //layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 24
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        
        self.collectionView.collectionViewLayout = layout
    }
    
    func setupList() {
        list.append("Red")
        list.append("Yellow")
        list.append("Green")
    }
    
}


//MARK: CollectionView
extension PageVCInContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        
        cell.titleLabel.text = list[indexPath.row]
        
        if indexPath.row == currentIndex {
            cell.titleLabel.textColor = .orange
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0, 1, 2:
            
            print("current indexPath row : \(indexPath.row)")
            print("current index: \(currentIndex)")
            
            if indexPath.row < currentIndex {
                pageViewController.setPreviousViewControllerFromIndex(index: indexPath.row)
            } else if indexPath.row > currentIndex {
                pageViewController.setNextViewControllerFromIndex(index: indexPath.row)
            }
            
            let cell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
            cell.titleLabel.textColor = .orange
            
            if let previousIndex = self.previousIndex {
                let prevCell = collectionView.cellForItem(at: IndexPath(row: previousIndex, section: 0)) as! CategoryCollectionViewCell
                prevCell.titleLabel.textColor = .black
            }
            
            
            break
        default: break
        }
    }
}
