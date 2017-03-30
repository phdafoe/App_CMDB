//
//  FavoritosViewController.swift
//  App_CMDB
//
//  Created by Andres on 30/3/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit
import Kingfisher

class FavoritosViewController: UIViewController {
    
    
    //MARK: - Varibales locales
    var movies = [MovieModel]()
    var collectionViewPadding : CGFloat = 0
    let dataProvider = LocalCoreDataService()
    var tapGR : UITapGestureRecognizer!
    
    
    
    //MARK: - IBOutltes
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPadding()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension FavoritosViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
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
    
}









