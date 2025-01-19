//
//  CurrencyListViewController.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import UIKit


import UIKit

class CurrencyListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView = UITableView()
    let cellReuseIdentifier = "cell"
    weak var currencyDelegate: FavoriteCurrencyProtocol?
    private var model: CurrencyListViewModel

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

extension CurrencyListViewController {

    func tableView(
        _ tableView: UITableView, heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return Constants.CurrencyListViewCell.cellHeight
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return model.dataModel.currencyList.count
    }

    private func tableView(
        tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath
    ) {
        //currencyDelegate?.addCurrencyAsFavorite(currency: model.dataModel.currencyList[indexPath.row])
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell: CurrencyListViewCell =
            tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
            as! CurrencyListViewCell
        cell.currency = model.dataModel.currencyList[indexPath.row]
        cell.backgroundColor = .clear
        return cell
    }
}
