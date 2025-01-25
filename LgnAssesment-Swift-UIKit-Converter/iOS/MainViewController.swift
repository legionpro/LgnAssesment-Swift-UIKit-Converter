//
//  ViewController.swift
//  LgnAssesment-Swift-UIKit-Converter
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import Combine
import OSLog
import UIKit

class MainViewController: UIViewController {

    var scrollViewConstraints: [NSLayoutConstraint] = []
    var pageControlConstraints: [NSLayoutConstraint] = []
    var favoriteCurrencyTableViewConstraints: [NSLayoutConstraint] = []

    private var box = Set<AnyCancellable>()
    private let childKeyBoard: KeyBoardViewControllerProtocol & UIViewController
    private var model:
        CurrencyListViewModelProtocol & ConvertingMethodsProtocol
            & ValuesListDataMapperProtocol
    private let favoriteCellReuseIdentifier = "favoritecell"

    private var timer: Timer?

    init(
        model: CurrencyListViewModelProtocol & ConvertingMethodsProtocol
            & ValuesListDataMapperProtocol,
        childKeyBoard: KeyBoardViewControllerProtocol & UIViewController
    ) {
        self.model = model
        self.childKeyBoard = childKeyBoard
        super.init(nibName: nil, bundle: nil)
        self.childKeyBoard.setUpKeyBoadrDelegate(self)
        self.keyBoardCurrencyScrollView.delegate = self
        self.favoriteCurrencyTableView.delegate = self
        self.favoriteCurrencyTableView.dataSource = self
        self.favoriteCurrencyTableView.register(
            FavoriteCurrencyViewCell.self,
            forCellReuseIdentifier: favoriteCellReuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var primaryCurrencySelectionFlag = false

    lazy private var keyboardSlideView: ItemSlideView = {
        var view = ItemSlideView()
        return view
    }()

    lazy private var currencySlideView: ItemSlideView = {
        var view = ItemSlideView()
        return view
    }()

    lazy var favoriteCurrencyTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()

    private lazy var keyBoardCurrencyScrollView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(
            CollectionViewCell.self,
            forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.collectionViewLayout = ColumnFlowLayout(cellsPerRow: 1)
        return collectionView
    }()

    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        return pageControl
    }()

    private func setupSubViews() {
        view.addSubview(keyBoardCurrencyScrollView)
        view.addSubview(pageControl)
        view.addSubview(favoriteCurrencyTableView)
        view.bringSubviewToFront(pageControl)
    }

    private func layoutViews() {
        layoutScrollView()
        layoutPageControl()
        layoutFavoriteCurrencyTableView()
    }

    func activateLayoutConstraints() {
        NSLayoutConstraint.activate(scrollViewConstraints)
        NSLayoutConstraint.activate(pageControlConstraints)
        NSLayoutConstraint.activate(favoriteCurrencyTableViewConstraints)
    }

    private func layoutScrollView() {
        keyBoardCurrencyScrollView.translatesAutoresizingMaskIntoConstraints =
            false
        scrollViewConstraints = [
            keyBoardCurrencyScrollView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            keyBoardCurrencyScrollView.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor,
                constant: Constants.mainController.contentMargines),
            keyBoardCurrencyScrollView.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor,
                constant: -1 * Constants.mainController.contentMargines),
            keyBoardCurrencyScrollView.heightAnchor.constraint(
                equalToConstant: view.frame.height / 2),
        ]
    }

    private func layoutPageControl() {
        pageControlConstraints = [
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
    }

    private func layoutFavoriteCurrencyTableView() {
        favoriteCurrencyTableView.translatesAutoresizingMaskIntoConstraints =
            false
        favoriteCurrencyTableViewConstraints = [
            favoriteCurrencyTableView.bottomAnchor.constraint(
                equalTo: pageControl.topAnchor, constant: 0),
            favoriteCurrencyTableView.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor,
                constant: Constants.FavoriteCurrencyTableView.contentMargin),
            favoriteCurrencyTableView.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor,
                constant: -1 * Constants.FavoriteCurrencyTableView.contentMargin
            ),
            favoriteCurrencyTableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constants.FavoriteCurrencyTableView.contentMargin),
        ]
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
        self.updateCurrencyValuesList(createTimerFlag: true)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutViews()
        activateLayoutConstraints()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {

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
            self.keyBoardCurrencyScrollView.scrollToItem(at: IndexPath(item: 1 , section: 0), at: .right, animated: true)
            self.keyBoardCurrencyScrollView.setNeedsLayout()
            self.model.curencyListElementPublisher.send(-1)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell: FavoriteCurrencyViewCell =
            tableView.dequeueReusableCell(
                withIdentifier: favoriteCellReuseIdentifier)
            as! FavoriteCurrencyViewCell
        let item = model.favoriteCurrencyList[indexPath.row]
        cell.setUpCellData(
            currency: item, value: model.getCurrencyValue(index: indexPath.row),
            failureFlag: model.failureFlag)
        if model.favoriteCurrencyList.count == (indexPath.row + 1) {
            cell.lastCellFlag = true
        } else {
            cell.lastCellFlag = false
        }
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

// Bindign publishera
extension MainViewController {
    private func setUpBinding() {
        bindListPublisher()
        bindPrimaryCurrencyValuePublisher()
    }

    private func bindPrimaryCurrencyValuePublisher() {
        model.primaryCurrencyValuePublisher
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] value in
                    self?.updateCurrencyValuesList(createTimerFlag: true)
                }
            )
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
        Logger.statistics.debug(
            "=== update currency values with flag: \(createTimerFlag) ===")
        if createTimerFlag {
            timer?.invalidate()
            timer = Timer.scheduledTimer(
                timeInterval: 10.0, target: self,
                selector: #selector(updateCurrencyValuesList), userInfo: nil,
                repeats: true)
        }
        model.updateCurrencyValuesList()
    }
}

// collection view delegates
extension MainViewController: UICollectionViewDelegate,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = self.keyBoardCurrencyScrollView.frame.width
        let height = self.keyBoardCurrencyScrollView.frame.height
        return CGSize(width: width, height: height)
    }

    // Return the number of items in the collection view section
    func collectionView(
        _ collectionView: UICollectionView, numberOfItemsInSection section: Int
    ) -> Int {
        return 2
    }

    // Configure and return the cell for a given index path
    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: CollectionViewCell.identifier,
                for: indexPath) as! CollectionViewCell
        let view: ItemSlideView
        if indexPath.row == 0 {
            view = ItemSlideView()
            self.add(childViewController: childKeyBoard, to: view)
            cell.customView = view
            cell.buttomView = UIView()
            cell.setupView()
        } else {
            view = ItemSlideView()
            self.add(
                childViewController: CurrencyListViewController(
                    model: self.model as! CurrencyListViewModel), to: view)
            cell.customView = view
            cell.setupView()
        }
        cell.backgroundColor = .clear
        return cell
    }
}
