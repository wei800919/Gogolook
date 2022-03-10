//
//  ViewController.swift
//  GogolookTest
//
//  Created by Xidi on 2022/2/28.
//

import UIKit

class AnimeViewController: UIViewController {
    
    @IBOutlet weak var animeCollectionView: UICollectionView!
    @IBOutlet weak var pickerParentView: UIView!
    @IBOutlet weak var typePickerView: UIPickerView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    var activityIndicatorView: UIActivityIndicatorView!
    var viewModel = AnimeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
        activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityIndicatorView.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        activityIndicatorView.center = self.view.center
        activityIndicatorView.tintColor = UIColor(named: "CutomNavigationBarTintColor")
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        viewModel.setup()
        viewModel.fetchAnimeList(mainType: self.viewModel.mainType)
        viewModel.onRequestEnd = {
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.title = "Anime List"
                self.animeCollectionView.reloadData()
                self.typePickerView.reloadComponent(1)
            }
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
    
    func setUI() {
        // fix ios 13 navigationbar appearance issue
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(named: "CutomBackButtonTintColor")]
            navBarAppearance.backgroundColor = UIColor(named: "CutomNavigationBarTintColor")
            self.navigationController?.navigationBar.standardAppearance = navBarAppearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
        
        typePickerView.backgroundColor = .systemGray
        toolBar.tintColor = .systemGray
        toolBar.backgroundColor = .lightGray
        rightBarButton.tintColor = UIColor(named: "CutomBackButtonTintColor")
    }
    
    func loadMore() {
        viewModel.page += 1
        activityIndicatorView.startAnimating()
        viewModel.fetchAnimeList(mainType: self.viewModel.mainType, isLoadMore: true)
        viewModel.onLoadMoreRequestEnd = {
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.animeCollectionView.reloadData()
            }
        }
    }
    
    @IBAction func rightBarButtonAction(_ sender: Any) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.pickerParentView.isHidden = false
        }
    }
    
    @IBAction func doneBarButtonAction(_ sender: Any) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
            self.activityIndicatorView.startAnimating()
            self.viewModel.fetchAnimeList(mainType: self.viewModel.mainType, isDone: true)
            self.viewModel.onDoneRequestEnd = {
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                    self.animeCollectionView.reloadData()
                }
            }
        } completion: { isFinished in
            self.pickerParentView.isHidden = true
        }
    }
}

extension AnimeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.top.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(AnimeCollectionViewCell.self)", for: indexPath) as? AnimeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.viewModel = viewModel
        cell.setup(top: viewModel.top[indexPath.row], index: indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width / 2
        let height = width * 1.67
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "showUrl", sender: viewModel.top[indexPath.row].url)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row + 1 == viewModel.top.count {
            self.activityIndicatorView.startAnimating()
            self.loadMore()
        }
    }
}

