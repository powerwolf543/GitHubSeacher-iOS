//
//  SearchViewController.swift
//  GitHubSeacher
//
//  Created by NixonShih on 2019/6/22.
//  Copyright © 2019 NixonShih. All rights reserved.
//

import UIKit
import SDWebImage

class SearchViewController: BaseViewController {
    
    var presenter: SearchViewPresenterSpec = SearchViewPresenter()
    
    // MARK: override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.delegate = self
        presenter.viewDidLoad()
    }
    
    // MARK: UI
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        collectionView.backgroundColor = .clear
        navigationItem.title = presenter.query
    }
}

extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numbersOfUsers()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: SearchCollectionViewCell.self, for: indexPath)
        cell.set(presenter.getUser(with: indexPath.row))
        presenter.loadMoreIfNeed(with: indexPath.row)
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {}

extension SearchViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - (16 * 3)) / 2
        let height = width + 50
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

extension SearchViewController: SearchViewPresenterDelegate {
    func reloadView() {
        collectionView.reloadData()
    }
}

class SearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var accountName: UILabel!
    
    func set(_ dataModel: UserModel) {
        accountName.text = dataModel.accountName
        avatarImageView.sd_setImage(with: URL(string: dataModel.imageURL))
    }
}

protocol SearchViewPresenterSpec {
    
    var query: String { get set }
    var delegate: SearchViewPresenterDelegate? { get set }
    
    func viewDidLoad()
    func loadMoreIfNeed(with row: Int)
    func numbersOfUsers() -> Int
    func getUser(with row: Int) -> UserModel
}

protocol SearchViewPresenterDelegate: class {
    func reloadView()
}

class SearchViewPresenter: SearchViewPresenterSpec {
    
    var query: String = ""
    weak var delegate: SearchViewPresenterDelegate?
    var seachUserFetcher: SeachUserFetcherSpec = SeachUserFetcher()
    
    func viewDidLoad() {
        fetchSearchResult()
    }
    
    func loadMoreIfNeed(with row: Int) {
        guard row == users.count - 1 else { return }
        fetchSearchResult()
    }
    
    func numbersOfUsers() -> Int {
        return users.count
    }
    
    func getUser(with row: Int) -> UserModel {
        return users[row]
    }
    
    // MARK: private
    
    enum Pagination {
        case more(nextPage: UInt)
        case none
    }
    
    enum Loading {
        case loading
        case none
    }
    
    private var users: [UserModel] = []
    private var task: Pagination = .more(nextPage: 1)
    private var loadingStatus: Loading = .none
    
    private func fetchSearchResult() {
        guard loadingStatus == .none else { return }
        guard case let .more(nextPage) = task else { return }
        loadingStatus = .loading
        
        seachUserFetcher.fetchForPaginationResponse(query: SeachUserFetcher.QueryModel(page: nextPage, query: query)) { [weak self] (result) in
            guard let self = self else { return }
            defer { self.loadingStatus = .none }
            switch result {
            case .success(let dataModel):
                self.task = dataModel.hasMore ? .more(nextPage: dataModel.currentPage + 1) : .none
                self.users += dataModel.dataModel
                self.delegate?.reloadView()
            case .failure(let error):
                print(error)
            }
        }
    }
}
