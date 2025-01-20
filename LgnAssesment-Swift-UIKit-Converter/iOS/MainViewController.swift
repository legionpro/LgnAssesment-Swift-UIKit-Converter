//
//  ViewController.swift
//  LgnAssesment-Swift-UIKit-Converter
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!

    private let childKeyBoard = KeyBoardViewController()
    private let model = CurrencyListViewModel()
    private let favoriteCellReuseIdentifier = "favoritecell"

    lazy private var keyboardSlideView: ItemSlideView = {
        var view = ItemSlideView()
        add(childViewController: childKeyBoard, to: view)
        return view
    }()

    lazy private var currencySlideView: ItemSlideView = {
        var view = ItemSlideView()
        let childController = CurrencyListViewController(model: self.model)
        add(childViewController: childController, to: view)
        return view
    }()

    lazy var favoriteCurrencyTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()

    let keyBoardCurrencyScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()

    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    private func setupSubViews() {
        view.addSubview(keyBoardCurrencyScrollView)
        view.addSubview(pageControl)
        view.addSubview(favoriteCurrencyTableView)
    }

    private func setupScrollView() {
        keyBoardCurrencyScrollView.delegate = self
        keyBoardCurrencyScrollView.contentInsetAdjustmentBehavior = .never
        setupSlideScrollView()
    }

    private func setupPageControl() {
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }

    private func layoutView() {
        layoutScrollView()
        layoutPageControl()
        layoutFavoriteCurrencyTableView()
    }

    private func layoutScrollView() {
        keyBoardCurrencyScrollView.translatesAutoresizingMaskIntoConstraints =
            false
        let constraints = [
            keyBoardCurrencyScrollView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor, constant: -1),
            keyBoardCurrencyScrollView.leftAnchor.constraint(
                equalTo: view.leftAnchor, constant: Constants.mainController.contentMargines),
            keyBoardCurrencyScrollView.rightAnchor.constraint(
                equalTo: view.rightAnchor, constant: -1 * Constants.mainController.contentMargines),
            keyBoardCurrencyScrollView.heightAnchor.constraint(
                equalToConstant: view.frame.height / 2),
        ]
        NSLayoutConstraint.activate(constraints)

    }

    private func layoutPageControl() {
        let constraints = [
            pageControl.bottomAnchor.constraint(
                equalTo: keyBoardCurrencyScrollView.topAnchor, constant: 0),
            pageControl.centerXAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: Constants.mainController.pageControlHeight)
        ]
        pageControl.pageIndicatorTintColor = Constants.color5.withAlphaComponent(0.3)
        pageControl.currentPageIndicatorTintColor = Constants.color5
        NSLayoutConstraint.activate(constraints)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barTintColor = Constants.color4
        self.navigationItem.title = "CONVERTER"
        self.navigationItem.titleView?.tintColor = Constants.color5
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.color5]

        self.view.backgroundColor = Constants.color4
        setupSubViews()
        setupScrollView()
        setupPageControl()
        setupFavoriteCurrencyTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        layoutView()
    }

    func setupSlideScrollView() {
        func setupKeyboardSlide() {
            keyboardSlideView.frame = CGRect(
                x: 0, y: 0, width: keyBoardCurrencyScrollView.frame.width - (2 * Constants.mainController.contentMargines),
                height: view.frame.height / 3)
            keyboardSlideView.backgroundColor = .clear
            keyBoardCurrencyScrollView.addSubview(keyboardSlideView)
        }

        func setupCurrencySlide() {
            currencySlideView.frame = CGRect(
                x: keyBoardCurrencyScrollView.frame.width - 16, y: 0, width: keyBoardCurrencyScrollView.frame.width - (2 * Constants.mainController.contentMargines),
                height: view.frame.height / 2)
            currencySlideView.backgroundColor = .clear
            keyBoardCurrencyScrollView.addSubview(currencySlideView)
        }

        keyBoardCurrencyScrollView.frame = CGRect(
            x: 0, y: 0, width: view.frame.width, height: view.frame.height / 2)
        
        keyBoardCurrencyScrollView.contentSize = CGSize(
            width: view.frame.width * CGFloat(2) - 2 * (2 * Constants.mainController.contentMargines), height: view.frame.height / 2)
        
        keyBoardCurrencyScrollView.isPagingEnabled = true

        setupKeyboardSlide()
        setupCurrencySlide()
        keyBoardCurrencyScrollView.layoutIfNeeded()
    }

}

extension MainViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        //slides[pageControl.currentPage].imageView.loadAndSetup(url: slides[pageControl.currentPage].url ?? "")
    }

    override func traitCollectionDidChange(
        _ previousTraitCollection: UITraitCollection?
    ) {
        setupSlideScrollView()
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    private func setupFavoriteCurrencyTableView() {
        favoriteCurrencyTableView.delegate = self
        favoriteCurrencyTableView.dataSource = self
        favoriteCurrencyTableView.register(
            FavoriteCurrencyViewCell.self,
            forCellReuseIdentifier: favoriteCellReuseIdentifier)
    }

    private func layoutFavoriteCurrencyTableView() {
        favoriteCurrencyTableView.translatesAutoresizingMaskIntoConstraints =
            false
        let constraints = [
            favoriteCurrencyTableView.bottomAnchor.constraint(
                equalTo: pageControl.topAnchor, constant: 0),
            favoriteCurrencyTableView.leftAnchor.constraint(
                equalTo: view.leftAnchor, constant: Constants.FavoriteCurrencyTableView.contentMargin),
            favoriteCurrencyTableView.rightAnchor.constraint(
                equalTo: view.rightAnchor, constant: -1 * Constants.FavoriteCurrencyTableView.contentMargin),
            favoriteCurrencyTableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.FavoriteCurrencyTableView.contentMargin),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func tableView(
        _ tableView: UITableView, heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return Constants.FavoriteCurrencyTableView.cellHeight
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return model.dataModel.favoriteCurrencyList.count
        //Constants.maxFavoriteCurrencyNumber
    }

    private func tableView(
        tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath
    ) {
        //favoriteCurrencyDelegate?.addCurrencyAsFavorite(currency: model.dataModel.currencyList[indexPath.row])
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell: FavoriteCurrencyViewCell =
            tableView.dequeueReusableCell(
                withIdentifier: favoriteCellReuseIdentifier)
            as! FavoriteCurrencyViewCell
        if model.dataModel.favoriteCurrencyList.count == (indexPath.row + 1) {
            cell.lastCellFlag = true
        }
        cell.currency = model.dataModel.favoriteCurrencyList[indexPath.row]
        cell.backgroundColor = .clear
        return cell
    }
}

extension MainViewController: KeyBoardProtocol {
    
    // TODO:
    func digitButtonTap(_ button: DigitButton) {

    }

    // TODO:
    func deleteButtonTap() {

    }

    // TODO:
    func delimiterButtonTap() {

    }

}


