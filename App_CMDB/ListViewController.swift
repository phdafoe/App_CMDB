//
//  ListViewController.swift
//  App_CMDB
//
//  Created by Andres on 30/3/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit
import Kingfisher

class ListViewController: UIViewController {
    
    //MARK: - Variables
    var movies = [MovieModel]()
    var collectionViewPadding : CGFloat = 0
    let customRefreshControll = UIRefreshControl()
    let dataProvider = LocalCoreDataService()
    var tapGR : UITapGestureRecognizer!
    
    
    
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        customRefreshControll.addTarget(self, action: #selector(loadData), for: .valueChanged)
        myCollectionView.refreshControl?.tintColor = CONSTANTES.COLORES_BASE.COLOR_BLANCO_GENERAL
        myCollectionView.refreshControl = customRefreshControll
        
        tapGR = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        loadData()
        
        setupPadding()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        mySearchBar.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    

}


extension ListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{

    //1 -> configuracion del padding del collection View
    func setupPadding(){
        let anchoPantalla = self.view.frame.width
        //aqui del todo el ancho me coges las 3 imagenes con el ancho que hemos preestablecido y me lo partes entre 4
        collectionViewPadding = (anchoPantalla - (3 * 113))/4
    }
    
    //2 -> Define los insets al borde de nuestra collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: collectionViewPadding,
                            left: collectionViewPadding,
                            bottom: collectionViewPadding,
                            right: collectionViewPadding)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewPadding
    }
    
    //4
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //5
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    //6
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCustomCell
        let movieData = movies[indexPath.row]
        configuredCell(cell, withMovie: movieData)
        return cell
    }
    
    //7
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 113, height: 170)
    }
    
    
    
    //MARK: - Utils
    func configuredCell(_ cell : MovieCustomCell, withMovie movie: MovieModel){
        if let imageData = movie.image{
            cell.myImageMovie.kf.setImage(with: ImageResource(downloadURL: URL(string: imageData)!),
                                          placeholder: #imageLiteral(resourceName: "img-loading"),
                                          options: nil,
                                          progressBlock: nil,
                                          completionHandler: nil)
        }
    }
    
    
    //MARK: - ****** SEARCH BAR +++++++//
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.view.addGestureRecognizer(tapGR)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            //Ejecutamos las busqueda 
            loadData()
        }
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let term = searchBar.text{
            dataProvider.searchMovie(term, remoteHandler: { (resultMovies) in
                if let moviesData = resultMovies{
                    self.movies = moviesData
                    //Cola 1 plano nos garantizara que este proceso se hara en el hilo principal
                    DispatchQueue.main.async {
                        self.myCollectionView.reloadData()
                        searchBar.resignFirstResponder()
                    }
                }
            })
        }
        
    }
    
    
    
    func hideKeyboard(){
        mySearchBar.resignFirstResponder()
        self.view.removeGestureRecognizer(tapGR)
    }
    
    
    func loadData(){
        dataProvider.topMovie({ (localResult) in
            
            if let moviesData = localResult{
                self.movies = moviesData
                //Cola 1 plano nos garantizara que este proceso se hara en el hilo principal
                DispatchQueue.main.async {
                    self.myCollectionView.reloadData()
                }
            }else{
                print("No hay registros en CoreData")
            }

            
        }) { (remoteResult) in
            
            
            if let moviesData = remoteResult{
                self.movies = moviesData
                //Cola 1 plano nos garantizara que este proceso se hara en el hilo principal
                DispatchQueue.main.async {
                    self.myCollectionView.reloadData()
                    self.customRefreshControll.endRefreshing()
                }
            }else{
                print("No hay registros en CoreData")
            }
        }
    }
    
    
    
    
    
    
    
    
}


















