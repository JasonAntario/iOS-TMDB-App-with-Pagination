//
//  ViewController.swift
//  iOS TMDB App with Pagination
//
//  Created by Dmitry Sankovsky on 6.01.23.
//

import UIKit

class MoviesListViewController: UIViewController {
    
    var isLoading = false
    var loadingView: LoadingReusableView?
    
    var moviesList = [Movie]()
    
    let viewModel = ViewModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let loadingReusableNib = UINib(nibName: K.REUSABLE_LOADING_CELL_NIB_NAME, bundle: nil)
        collectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: K.REUSABLE_LOADING_CELL_ID)
        
        let itemReusableNib = UINib(nibName: K.REUSABLE_ITEM_CELL_NIB_NAME, bundle: nil)
        collectionView.register(itemReusableNib, forCellWithReuseIdentifier: K.REUSABLE_ITEM_CELL_ID)
        
        bindViewModel()
        loadData()
    }
    
    func bindViewModel(){
        viewModel.movies.bind({ (movies) in
            DispatchQueue.main.async {
                self.moviesList = movies
                self.collectionView.reloadData()
                self.isLoading = false
            }
        })
    }
    
    func loadData(){
        if !self.isLoading {
            self.isLoading = true
            viewModel.fetchData()
        }
    }
}

extension MoviesListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.SEGUE_ID_MOVIE_DETAILS, sender: self)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MovieDetailsViewController
        if let indexPath = collectionView.indexPathsForSelectedItems?.first {
            destinationVC.movieId = moviesList[indexPath.row].id
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.REUSABLE_ITEM_CELL_ID, for: indexPath) as! ItemReusableView
        
        let item = moviesList[indexPath.row]
        cell.titleLabel.text = item.originalTitle
        if let url = URL(string: K.IMAGE_BASE_URL + item.posterPath){
            cell.posterView.load(url: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.row == moviesList.count - 2 && !self.isLoading {
            loadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter{
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: K.REUSABLE_LOADING_CELL_ID, for: indexPath) as! LoadingReusableView
            loadingView = aFooterView
            loadingView?.backgroundColor = UIColor.clear
            return aFooterView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.loadingIndicator.startAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.loadingIndicator.stopAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if self.isLoading {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
