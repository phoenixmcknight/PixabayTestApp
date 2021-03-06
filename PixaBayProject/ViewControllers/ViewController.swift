//
//  ViewController.swift
//  PixaBayProject
//
//  Created by Phoenix McKnight on 5/4/20.
//  Copyright © 2020 Phoenix McKnight. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pixaActivityIndc: UIActivityIndicatorView!
    
    @IBOutlet weak var pixaCollectionView: UICollectionView!
    
    @IBOutlet weak var pixaSearchBar: UISearchBar!
    
    @IBOutlet weak var userNameFilterSearchBar: UISearchBar!
    
    private var lastContentOffset: CGFloat = 0
    
    private var scrollDirection:ScrollDirection = .none
    
    private var retrievingDataInProgress:Bool = false
    
    private var currentPage:Int = 1
    
    private var request:PixaRequest = PixaRequest()
    
    
    var pictureData = [Hit]() {
        didSet {
            pixaCollectionView.reloadData()
        }
    }
    
    
    var searchString:String? = nil {
        didSet {
            pixaCollectionView.reloadData()
            isFiltering = searchString != nil
        }
    }
    
    var searchTerm:String = ""
    
    var isFiltering = false
    
    var filteredPictureData:[Hit] {
        guard let searchString = searchString else {return pictureData}
        
        guard searchString.isEmpty == false else {return pictureData}
        
        
        return pictureData.filter({(($0.user ?? "Username Unavailable").lowercased().contains(searchString.lowercased()))})
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addDelegatesAndDataSource()
        assignLayoutToCollectionView()
        TestModel.testNumber = 10
    
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pixaSearchBar.hideSmallXCancelButton()
        userNameFilterSearchBar.hideSmallXCancelButton()
    }
    
    private func assignLayoutToCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        pixaCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func addDelegatesAndDataSource() {
        pixaSearchBar.delegate = self
        userNameFilterSearchBar.delegate = self
        pixaCollectionView.dataSource = self
        pixaCollectionView.delegate = self
        pixaCollectionView.prefetchDataSource = self
            }
    
    
    private func loadPixaData(search:String) {
        guard  !retrievingDataInProgress else {return}
     retrievingDataInProgress = true
        pixaActivityIndc.startAnimating()
        PictureAPIClient.manager.getPicturesFromAPI(requestTwo: request, searchTerm: search,currentPage: currentPage) { [weak self] (result) in
            switch result {
            case .failure:
                self?.retrievingDataInProgress = false
                self?.showAlert(title: "Error", message: "Could Not Load Images For '\(search)'. Please Try Again Using a Different Search Term")
                self?.pixaActivityIndc.stopAnimating()
            case .success(let hits):
                
             //   self?.pictureData.append(contentsOf: hits)
                self?.pictureData.append(contentsOf: hits)
                if self!.currentPage > 1 {
                    
                   
                    guard let indexPathsToReload = self?.calculateIndexPathsToReload(from: hits) else {
                        self?.pixaCollectionView.reloadData()
                       // self?.currentPage += 1
                        self?.retrievingDataInProgress = false
                        self?.pixaActivityIndc.stopAnimating()
                        return
                    }
                    let reloadIndexes = self?.visibleIndexPathsToReload(intersecting: indexPathsToReload)
                    
                    self?.pixaCollectionView.reloadItems(at: reloadIndexes!)
                   


                } else {
                       self?.showFilterSearchBar()
                    self?.pixaCollectionView.reloadData()
                }
//
                self?.currentPage += 1
                self?.retrievingDataInProgress = false
                self?.pixaActivityIndc.stopAnimating()
                
            }
        }
    }
    
    private func calculateIndexPathsToReload(from pictures: [Hit]) -> [IndexPath] {
        let startIndex = pictureData.count - pictures.count
        let endIndex = startIndex + pictures.count
      return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    private func showFilterSearchBar() {
        guard self.userNameFilterSearchBar.alpha == 0 else {return}
        UIView.animate(withDuration: 0.5) { 
            self.userNameFilterSearchBar.alpha = 1
        }
    }
}


extension ViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDataSourcePrefetching {
    
   
   
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        for index in indexPaths {
//            if isLoadingCell(for: index) {
//                loadPixaData(search: searchTerm)
//            }
//        }
        if indexPaths.contains(where: isLoadingCell) {
           loadPixaData(search: searchTerm)
         }
        print("prefetching",indexPaths)
    
    }
   
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredPictureData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pixa", for: indexPath) as? PixaCollectionViewCell else {return UICollectionViewCell()}
        
        let currentHit = filteredPictureData[indexPath.item]
        
        cell.cellLabelAnimation()
        cell.setUpCell(hit: currentHit)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard isFiltering == false else {return}
        
        
        cell.alpha = 0
        
        switch scrollDirection {
            
        case .up:
            cell.transform = CGAffineTransform(translationX: view.frame.maxX, y: 0)
        case .down:
            cell.transform = CGAffineTransform(translationX: view.frame.minX - view.frame.maxX, y: 0)
        case .none:
            cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
        
        UIView.animate(
            withDuration:0.75,
            delay: 0.25,
            animations: {
                cell.alpha = 1
                cell.transform = .identity
        })
    }
    

    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      
        if self.lastContentOffset < scrollView.contentOffset.y {
            scrollDirection = .up
            
        } else if self.lastContentOffset > scrollView.contentOffset.y {
            scrollDirection = .down
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let detailVC =    storyBoard.instantiateViewController(identifier: "DetailVC") as? DetailViewController else {return}
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? PixaCollectionViewCell else {return}
        pixaActivityIndc.startAnimating()
        
        detailVC.pixaImage = cell.pixaImageView.image
        detailVC.currentHit = filteredPictureData[indexPath.item]
        
        detailVC.modalPresentationStyle = .formSheet
        
        UIView.animate(withDuration: 0.25, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (_) in
            UIView.animate(withDuration: 0.25, animations: {
                cell.transform = .identity
            }) { (_) in
                self.present(detailVC,animated: true)
            }
        }
        pixaActivityIndc.stopAnimating()
    }
}

extension ViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 250, height: 250)
    }
}

extension ViewController:UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        switch searchBar.tag {
        case 0:
            pixaSearchBar.showsCancelButton = true
        default:
            userNameFilterSearchBar.showsCancelButton = true
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        switch searchBar.tag {
        case 0:
            pixaSearchBar.text = ""
            userNameFilterSearchBar.text = ""
            pixaSearchBar.showsCancelButton = false
            
        default:
            userNameFilterSearchBar.text = ""
            userNameFilterSearchBar.showsCancelButton = false
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard searchBar.tag == 0 else {return}
        
        guard let search = pixaSearchBar.text else {return}
        searchTerm = search
        scrollDirection = .none
        userNameFilterSearchBar.text = ""
        searchString = nil
        loadPixaData(search: searchTerm)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchBar.tag == 1 else {return}
        searchString = searchText
        if searchText == "" {
            scrollDirection = .none
            isFiltering = false
            
        }
    }
}

extension ViewController {
    private enum ScrollDirection {
        case up
        case down
        case none
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
      return indexPath.row >= pictureData.count - 1
    }

    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = pixaCollectionView.indexPathsForVisibleItems
      let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
      return Array(indexPathsIntersection)
    }
}
