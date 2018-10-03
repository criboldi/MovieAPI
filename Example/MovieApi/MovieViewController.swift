//
//  MovieViewController.swift
//  MovieApi_Example
//
//  Created by Christian Riboldi on 10/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import MovieApi

class MovieViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var director: UILabel!
    @IBOutlet weak var actors: UILabel!
    @IBOutlet weak var plot: UILabel!
    
    var movie: Movie!
    
    static func initFromStoryboard(movie: Movie) -> MovieViewController? {
        guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieViewController") as? MovieViewController else {
            return nil
        }
        vc.movie = movie
        return vc
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.titleLabel.text = movie.title
        self.year.text = movie.year
        self.id.text = movie.id
        self.type.text = movie.type.rawValue
        self.genre.text = movie.genre
        self.director.text = movie.director
        self.actors.text = movie.actors
        self.plot.text = movie.plot
    }

}
