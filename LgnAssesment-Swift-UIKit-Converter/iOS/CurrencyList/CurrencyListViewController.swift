//
//  CurrencyListViewController.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import UIKit

class CurrencyListViewController: UIViewController {

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
        self.view.backgroundColor = Constants.color4
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
        if !model.mainList[indexPath.row].isPrimary {
            model.changeFavorite(at: indexPath.row)
            model.curencyListElementPublisher.send(indexPath.row)
        }
            
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell: CurrencyListViewCell =
            tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
            as! CurrencyListViewCell
        let item = model.mainList[indexPath.row]
        cell.currency = item
        //cell.showFavoriteFlag = false
        if item.isPrimary {
            cell.backgroundColor = Constants.keyBoardColorisHighlighted
        } else {
            cell.backgroundColor = .clear
        }
        return cell
    }
}
