//
//  HomeViewController.swift
//  MovieApp
//
//  Created by hayrı oguz on 24.10.2020.
//

import UIKit

class HomeViewController: MovieAppBaseViewController {

    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    
    //MARK: variables
    var movieDataSet: [MovieModel] = []
    var searchedMovieDataSet: [MovieModel] = []
    var showType = ShowingType.grid {
        didSet {
            setButtonIcon()
            setCollectionViewShowType()
        }
    }
    var page: Int = 1
    var hasNextPage: Bool = true
    var isNetworkInProgress: Bool = false
    
    //MARK: Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        fetchMoviesData()
        reloadCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadCollectionView()
    }
    
    override func rightBarTapped(_ sender: UIBarButtonItem) {
        showType.toggle()
    }
    
    
    //MARK: Helper Functions
    fileprivate func setUI() {
        setCollectionView()
        super.embedRightBarItem(icon: UIImage(named: "grid"))
        self.showType = .grid
        searchTextField.delegate = self
        searchTextField.autocorrectionType = .no
        searchTextField.addTarget(self, action: #selector(searchMovie), for: .editingChanged)
    }
    fileprivate func setCollectionView() {
        // Register movies collectionView
        self.moviesCollectionView.delegate = self
        self.moviesCollectionView.dataSource = self
        self.moviesCollectionView.register(UINib(nibName: "MoviesCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "MoviesCollectionViewCell")
        self.moviesCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.moviesCollectionView.prefetchDataSource = self
        
    }
    
    fileprivate func reloadCollectionView() {
        self.moviesCollectionView.performBatchUpdates({
            self.moviesCollectionView.reloadSections(IndexSet(integersIn: 0..<self.moviesCollectionView.numberOfSections))
        }) { (_) in
        }
    }
    
    fileprivate func goMovieDetailView(movieId: Int) {
        if let vc = UIStoryboard(name: "MovieDetail", bundle: .main).instantiateViewController(identifier: "MovieDetailViewController") as? MovieDetailViewController {
            vc.movieId = movieId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    fileprivate func setButtonIcon() {
        if let barItem = self.navigationItem.rightBarButtonItem {
            barItem.image = self.showType.icon
        }
    }
    
    fileprivate func setCollectionViewShowType() {
        if let layout = moviesCollectionView.collectionViewLayout as? MovieCollectionLayout {
            layout.showType = self.showType
            self.reloadCollectionView()
        }
    }
    
    @objc func searchMovie() {
        if searchTextField.text == "" {
            searchedMovieDataSet = movieDataSet
        } else {
            let filter = movieDataSet.filter {
                $0.title.lowercased().contains(searchTextField.text ?? "")
            }
            searchedMovieDataSet = filter
        }
        reloadCollectionView()
    }
    
    //MARK: Fetch Data Function
    
    fileprivate func fetchMoviesData() {
        guard !isNetworkInProgress else {return}
        isNetworkInProgress = true
        MovieManager.shared.fetchPopularMoviesList(page: self.page) { (response) in
            self.isNetworkInProgress = false
            self.page = response.page + 1
            self.hasNextPage = !(self.page >= response.total_pages)
            DispatchQueue.main.async {
                self.movieDataSet.append(contentsOf: response.results)
                self.searchedMovieDataSet = self.movieDataSet
                self.reloadCollectionView()
            }
        } onError: { (error) in
            self.isNetworkInProgress = false
            DispatchQueue.main.async {
                self.showErrorPopup(message: error)
            }
        }

    }
}

//MARK: Collection View Delegate Methods
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedMovieDataSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionViewCell", for: indexPath) as? MoviesCollectionViewCell {
            cell.setCell(model: searchedMovieDataSet[indexPath.item])
            return cell
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goMovieDetailView(movieId: searchedMovieDataSet[indexPath.item].id)
    }
    
    
}
//MARK: Collection View Prefetcihg Delegate
extension HomeViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLastCell(indexPath:)), self.hasNextPage {
            fetchNewPage()
        }
    }
    
    private func isLastCell(indexPath: IndexPath) -> Bool {
        return indexPath.item >= searchedMovieDataSet.count - 1
    }
    
    private func fetchNewPage() {
        fetchMoviesData()
    }
    
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
