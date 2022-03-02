//
//  ViewController.swift
//  GogolookTest
//
//  Created by Xidi on 2022/2/28.
//

import UIKit

class AnimeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var animeTableView: UITableView!
    
    var activityIndicatorView: UIActivityIndicatorView!
    var viewModel = AnimeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Anime List"
        self.navigationController?.navigationBar.tintColor = .white
        
        viewModel.setup()
        viewModel.fetchAnimeList()
        viewModel.onRequestEnd = {
            self.animeTableView.reloadData()
        }
        
        viewModel.onRequestError = { [weak self] error in
            self?.showAPIFailAlert(error: error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUrl" {
            if let viewController = segue.destination as? AnimeDetailViewController,
                let url = sender as? String {
                viewController.urlString = url
            }
        }
    }
    
    func loadMore() {
        viewModel.page += 1
        viewModel.fetchAnimeList(isLoadMore: true)
        viewModel.onRequestEnd = {
            self.activityIndicatorView.stopAnimating()
            self.animeTableView.reloadData()
            print(self.viewModel.top.count)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.top.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AnimeTableViewCell else {
            return UITableViewCell()
        }
        
        cell.viewModel = viewModel
        cell.setup(top: viewModel.top[indexPath.row], index: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "showUrl", sender: viewModel.top[indexPath.row].url)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == viewModel.top.count {
            print("do something")
            activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
            activityIndicatorView.startAnimating()
            activityIndicatorView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
            self.animeTableView.tableFooterView = activityIndicatorView
            self.animeTableView.tableFooterView?.isHidden = false
            self.loadMore()
        }
    }
}

