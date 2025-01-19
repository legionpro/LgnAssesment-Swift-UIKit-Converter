//
//  ViewController.swift
//  LgnAssesment-Swift-UIKit-Converter
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import UIKit

class ViewController: UIViewController {

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
        tableView.backgroundColor = .yellow
        return tableView
    }()

    let keyBoardCurrencyScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .yellow
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

        keyBoardCurrencyScrollView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor, constant: 1
        ).isActive = true
        keyBoardCurrencyScrollView.leftAnchor.constraint(
            equalTo: view.leftAnchor, constant: 8
        ).isActive = true
        keyBoardCurrencyScrollView.rightAnchor.constraint(
            equalTo: view.rightAnchor, constant: -8
        ).isActive = true
        keyBoardCurrencyScrollView.heightAnchor.constraint(
            equalToConstant: view.frame.height / 2
        ).isActive = true

    }

    private func layoutPageControl() {
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(
                equalTo: keyBoardCurrencyScrollView.topAnchor, constant: 0),
            pageControl.centerXAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
        pageControl.heightAnchor.constraint(equalToConstant: 60).isActive = true
        pageControl.pageIndicatorTintColor = .darkGray
        pageControl.currentPageIndicatorTintColor = .systemBlue
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "some title"
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
                x: 0, y: 0, width: view.frame.width,
                height: view.frame.height / 2)
            keyboardSlideView.backgroundColor = .green
            keyBoardCurrencyScrollView.addSubview(keyboardSlideView)
        }

        func setupCurrencySlide() {
            currencySlideView.frame = CGRect(
                x: view.frame.width, y: 0, width: view.frame.width,
                height: view.frame.height / 2)
            currencySlideView.backgroundColor = .blue
            keyBoardCurrencyScrollView.addSubview(currencySlideView)
        }

        keyBoardCurrencyScrollView.frame = CGRect(
            x: 0, y: 0, width: view.frame.width, height: view.frame.height / 2)
        keyBoardCurrencyScrollView.contentSize = CGSize(
            width: view.frame.width * CGFloat(2), height: view.frame.height / 2)
        keyBoardCurrencyScrollView.isPagingEnabled = true

        setupKeyboardSlide()
        setupCurrencySlide()
        keyBoardCurrencyScrollView.layoutIfNeeded()
    }

}

extension ViewController: UIScrollViewDelegate {

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

extension ViewController: KeyBoardProtocol {
    
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

extension ViewController: UITableViewDelegate, UITableViewDataSource {

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
        NSLayoutConstraint.activate([
            favoriteCurrencyTableView.bottomAnchor.constraint(
                equalTo: pageControl.topAnchor, constant: 0),
            favoriteCurrencyTableView.leftAnchor.constraint(
                equalTo: view.leftAnchor, constant: 8),
            favoriteCurrencyTableView.rightAnchor.constraint(
                equalTo: view.rightAnchor, constant: -8),
            favoriteCurrencyTableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
        ])
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
        return cell
    }
}
