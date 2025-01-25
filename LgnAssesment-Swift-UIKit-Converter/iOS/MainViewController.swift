//
//  ViewController.swift
//  LgnAssesment-Swift-UIKit-Converter
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import Combine
import UIKit
import OSLog

class MainViewController: UIViewController, FavoriteCurrencyProtocol {

    private var box = Set<AnyCancellable>()
    private let childKeyBoard: KeyBoardViewControllerProtocol & UIViewController
    private var model: CurrencyListViewModelProtocol & ConvertingMethodsProtocol & ValuesListDataMapperProtocol
    private let favoriteCellReuseIdentifier = "favoritecell"

    private var timer: Timer?
    
    init(model: CurrencyListViewModelProtocol & ConvertingMethodsProtocol & ValuesListDataMapperProtocol, childKeyBoard: KeyBoardViewControllerProtocol & UIViewController) {
        self.model = model
        self.childKeyBoard = childKeyBoard
        super.init(nibName: nil, bundle: nil)
        self.childKeyBoard.setUpKeyBoadrDelegate(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var primaryCurrencySelectionFlag = false

    lazy private var keyboardSlideView: ItemSlideView = {
        var view = ItemSlideView()
        add(childViewController: childKeyBoard, to: view)
        return view
    }()

    lazy private var currencySlideView: ItemSlideView = {
        var view = ItemSlideView()
        let childController = CurrencyListViewController(
            model: self.model as! CurrencyListViewModel)
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
                equalTo: view.leftAnchor,
                constant: Constants.mainController.contentMargines),
            keyBoardCurrencyScrollView.rightAnchor.constraint(
                equalTo: view.rightAnchor,
                constant: -1 * Constants.mainController.contentMargines),
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
            pageControl.heightAnchor.constraint(
                equalToConstant: Constants.mainController.pageControlHeight),
        ]
        pageControl.pageIndicatorTintColor = Constants.color5
            .withAlphaComponent(0.3)
        pageControl.currentPageIndicatorTintColor = Constants.color5
        NSLayoutConstraint.activate(constraints)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barTintColor = Constants.color4
        self.navigationItem.title = "CONVERTER"
        self.navigationItem.titleView?.tintColor = Constants.color5
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Constants.color5
        ]

        self.view.backgroundColor = Constants.color4
        setupSubViews()
        setupScrollView()
        setupPageControl()
        setupFavoriteCurrencyTableView()
        setUpBinding()

        let _ = NotificationCenter.default.addObserver(
            self, selector: #selector(appMovedToBackground),
            name: UIApplication.willResignActiveNotification, object: nil)
    }

    @objc func appMovedToBackground() {
        if !self.model.failureFlag {
            model.setDataToUserDefaults()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        layoutView()
        favoriteCurrencyTableView.reloadData()
        self.updateCurrencyValuesList(createTimerFlag: true)
    }
    
    func setupSlideScrollView() {
        func setupKeyboardSlide() {
            keyboardSlideView.frame = CGRect(
                x: 0, y: 0,
                width: keyBoardCurrencyScrollView.frame.width
                    - (2 * Constants.mainController.contentMargines),
                height: view.frame.height / 3)
            keyboardSlideView.backgroundColor = .clear
            keyBoardCurrencyScrollView.addSubview(keyboardSlideView)
        }

        func setupCurrencySlide() {
            currencySlideView.frame = CGRect(
                x: keyBoardCurrencyScrollView.frame.width - 16, y: 0,
                width: keyBoardCurrencyScrollView.frame.width
                    - (2 * Constants.mainController.contentMargines),
                height: view.frame.height / 2)
            currencySlideView.backgroundColor = .clear
            keyBoardCurrencyScrollView.addSubview(currencySlideView)
        }

        keyBoardCurrencyScrollView.frame = CGRect(
            x: 0, y: 0, width: view.frame.width, height: view.frame.height / 2)

        keyBoardCurrencyScrollView.contentSize = CGSize(
            width: view.frame.width * CGFloat(2) - 2
                * (2 * Constants.mainController.contentMargines),
            height: view.frame.height / 2)

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
                equalTo: view.leftAnchor,
                constant: Constants.FavoriteCurrencyTableView.contentMargin),
            favoriteCurrencyTableView.rightAnchor.constraint(
                equalTo: view.rightAnchor,
                constant: -1 * Constants.FavoriteCurrencyTableView.contentMargin
            ),
            favoriteCurrencyTableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constants.FavoriteCurrencyTableView.contentMargin),
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
        return model.favoriteCurrencyList.count
    }

    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        model.primaryCurrencySelectionFlag =
            model.favoriteCurrencyList[indexPath.row].isPrimary
        model.curencyListElementPublisher.send(-1)
        keyBoardCurrencyScrollView.scrollToView(
            view: currencySlideView, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell: FavoriteCurrencyViewCell =
            tableView.dequeueReusableCell(
                withIdentifier: favoriteCellReuseIdentifier)
            as! FavoriteCurrencyViewCell
        let item = model.favoriteCurrencyList[indexPath.row]
        cell.setUpCellData(currency: item,  value: model.getCurrencyValue(index: indexPath.row), failureFlag: model.failureFlag)
        if model.favoriteCurrencyList.count == (indexPath.row + 1) {
            cell.lastCellFlag = true
        } else {
            cell.lastCellFlag = false
        }
        //cell.failureMessageFlag = model.failureFlag
        cell.backgroundColor = .clear
        return cell
    }
}

extension MainViewController: KeyBoardProtocol {

    func digitButtonTap(_ tag: BoardKeysTags) {
        _ = model.addSymbolToPrimaryValue(tag)
    }

    func delimiterButtonTap() {
        _ = model.addSymbolToPrimaryValue(.delimiter)
    }
    
    func deleteButtonTap() {
        _ = model.deleteSymbolFromToPrimaryValue()
    }

    func clearButtonTap() {
        _ = model.cleanToPrimaryValue()
    }
}

extension MainViewController {
    private func setUpBinding() {
        bindList()
        bindListPublisher()
        bindPrimaryCurrencyValuePublisher()
    }

    private func bindPrimaryCurrencyValuePublisher() {
        model.primaryCurrencyValuePublisher
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                self?.updateCurrencyValuesList(createTimerFlag: true)
            })
            .store(in: &box)
    }
    
    private func bindList() {
                model.curencyListElementPublisher
                    .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                        self!.favoriteCurrencyTableView.reloadData()
                    })
                    .store(in: &box)
    }

    private func bindListPublisher() {
        model.curencyListElementPublisher
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] value in
                    self!.favoriteCurrencyTableView.reloadData()
                }
            )
            .store(in: &box)
    }
    
    
    // update currencies values  from network, recreate timer when it fiers not by timer
    @objc private func updateCurrencyValuesList(createTimerFlag: Bool = false) {
        Logger.statistics.debug("=== update currency values with flag: \(createTimerFlag) ===")
        if createTimerFlag {
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(updateCurrencyValuesList), userInfo: nil, repeats: true)
        }
        model.updateCurrencyValuesList()
    }
}
