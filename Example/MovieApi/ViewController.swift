//
//  ViewController.swift
//  MovieApi
//
//  Created by criboldi on 09/28/2018.
//  Copyright (c) 2018 criboldi. All rights reserved.
//

import UIKit
import MovieApi

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [Movie]?
    let networkManager = NetworkManager(.xml)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        
        guard let text = textField.text, !text.isEmpty else {
            print("text is empty")
            return
        }
        networkManager.searchForMovie(withTitle: text) { (movies, error) in
            if let error = error {
                print("returned error: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                print("returned with \(movies?.count ?? 0) movies")
                self.movies = movies
                self.tableView.reloadData()
            }
        }
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let movie = movies?[indexPath.row] else { return }
        
        self.networkManager.getMovie(byId: movie.id) { (movie, error) in
            if let error = error {
                print("returned error: \(error)")
                return
            }
            
            if let movie = movie {
                DispatchQueue.main.async {
                    guard let movieVC = MovieViewController.initFromStoryboard(movie: movie) else {
                        return
                    }
                    self.navigationController?.pushViewController(movieVC, animated: true)
                }
            }            
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? movies?.count ?? 0 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        cell.textLabel?.text = movies?[indexPath.row].title
        cell.detailTextLabel?.text = movies?[indexPath.row].year
        return cell
    }
    
}

