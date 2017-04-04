//
//  DetallePeliculaViewController.swift
//  App_CMDB
//
//  Created by Andres on 30/3/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit
import Kingfisher


class DetallePeliculaViewController: UIViewController {
    
    //MARK: - Variables locales
    var movie : MovieModel?
    let dataProvider = LocalCoreDataService()
    
    
    
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var myImagePelicula: UIImageView!
    @IBOutlet weak var myTituloPelicula: UILabel!
    @IBOutlet weak var myDirectorPelicula: UILabel!
    @IBOutlet weak var myCategoriaPelicula: UILabel!
    @IBOutlet weak var myButtonBTN: UIButton!
    @IBOutlet weak var mySinopsisTV: UITextView!
    
    
    //MARK: - IBActions
    @IBAction func peliculaFavoritaACTION(_ sender: Any) {
        if let movieData = movie{
            dataProvider.markUnMarkFavorite(movieData)
            configuredFavoriteBTN()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mySinopsisTV.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //comprobaremos que tenemos un peli en el VC y le seteamos la info
        if let movieData = movie{
            
            //imagen
            if let imageData = movieData.image{
                myImagePelicula.kf.setImage(with: ImageResource(downloadURL: URL(string: imageData)!))
            }
            //Title
            myTituloPelicula.text = movieData.title
            self.title = movieData.title
            //Summary
            mySinopsisTV.text = movieData.summary
            //Categoria
            myCategoriaPelicula.text = movieData.category
            //Director
            myDirectorPelicula.text = movieData.director
            
            configuredFavoriteBTN()
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Utils
    func configuredFavoriteBTN(){
        if let movieData = movie{
            if dataProvider.isMovieFavorite(movieData){
                myButtonBTN.setBackgroundImage(#imageLiteral(resourceName: "btn-on"), for: .normal)
                myButtonBTN.setTitle("Quiero verla!", for: .normal)
            }else{
                myButtonBTN.setBackgroundImage(#imageLiteral(resourceName: "btn-off"), for: .normal)
                myButtonBTN.setTitle("No me interesa", for: .normal)
            }
        }
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
