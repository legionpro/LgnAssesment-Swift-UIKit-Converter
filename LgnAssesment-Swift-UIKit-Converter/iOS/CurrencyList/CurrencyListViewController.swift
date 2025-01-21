//
//  CurrencyListViewController.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import UIKit
import Combine

class CurrencyListViewController: UIViewController {

    private var box = Set<AnyCancellable>()
    var tableView: UITableView = UITableView()
    let cellReuseIdentifier = "cell"
    weak var currencyDelegate: FavoriteCurrencyProtocol?
    private var model: CurrencyListViewModelProtocol

    init(model: CurrencyListViewModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCurrencyTableView()
        setUpBinding()
        self.view.backgroundColor = Constants.color4
    }
    
//    override func  viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        print("------------------------0-00----------------------")
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        print("------------------------0-----------------------")
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        model.primaryCurrencySelectionFlag = false
//        print("---------------------1--------------------------")
//    }
    func reloadCurrencyList() {
        tableView.reloadData()
    }
    
    private func setupCurrencyTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            CurrencyListViewCell.self,
            forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.backgroundColor = .clear
        self.view.addSubview(tableView)
        
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = self.view.frame
    }
}

extension CurrencyListViewController {
    private func setUpBinding() {
        bindListPublisher()
    }
    
    private func bindListPublisher() {
        model.curencyListElementPublisher
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                self!.reloadCurrencyList()
            })
            .store(in: &box)
    }
}

extension CurrencyListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(
        _ tableView: UITableView, heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return Constants.CurrencyListViewCell.cellHeight
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return model.mainList.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !model.primaryCurrencySelectionFlag {
            if !model.mainList[indexPath.row].isPrimary {
                model.toggleFavorite(at: indexPath.row)
            }
        } else {
            if !model.mainList[indexPath.row].isPrimary {
                model.setPrimary(at: indexPath.row)
            }
        }
            
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell: CurrencyListViewCell =
            tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
            as! CurrencyListViewCell
        let item = model.mainList[indexPath.row]
        cell.showFavoriteFlag = model.primaryCurrencySelectionFlag
        cell.setUpCellData(item)
        if item.isPrimary {
            cell.backgroundColor = Constants.keyBoardColorisHighlighted
        } else {
            cell.backgroundColor = .clear
        }
        return cell
    }
}
