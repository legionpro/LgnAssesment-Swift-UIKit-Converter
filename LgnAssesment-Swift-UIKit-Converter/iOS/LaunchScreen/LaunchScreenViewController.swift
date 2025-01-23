//
//  LaunchScreenViewController.swift
//  iOS
//
//  Created by Oleh Poremskyy on 20.01.2025.
//

import Lottie
import UIKit

final class LaunchScreenViewController: UIViewController {
    private var animationView: LottieAnimationView?
    private let contentView = UIView()

    let contentLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "continent.soft@gmail.com"
        lbl.backgroundColor = .clear
        lbl.textColor = .black
        lbl.textAlignment = .center
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.color1
        setupAnimationView()
    }

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        layoutAnimationView()
        layoutContentView()
        layoutcontentLabel()
    }

    private func setupAnimationView() {
        animationView = .init(name: "splashAnimation.json")
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .repeat(3)
        animationView!.animationSpeed = 0.5
        contentView.backgroundColor = Constants.color4.withAlphaComponent(0.1)
        contentView.addSubview(contentLabel)
        self.view.addSubview(contentView)
        self.view.addSubview(animationView!)
        animationView!.play(completion: { (finished) in
            let model = CurrencyListViewModel(dataModel: CurrencyListModel(convertingValues: ConvertingValues()), networkService: NetworkService() )
            let kvc = KeyBoardViewController(boardView: NumericKeyboard())
            let vc = MainViewController(model: model, childKeyBoard: kvc)
            self.navigationController?.setViewControllers([vc], animated: false)
        })
    }

    private func layoutAnimationView() {
        guard let aview = animationView else { return }
        aview.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            aview.topAnchor.constraint(
                equalTo: self.view.topAnchor, constant: 100),
            aview.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            aview.widthAnchor.constraint(
                equalToConstant: self.view.bounds.width),
            aview.heightAnchor.constraint(
                equalToConstant: self.view.bounds.height / 2),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func layoutContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            contentView.bottomAnchor.constraint(
                equalTo: self.view.bottomAnchor, constant: -100),
            contentView.centerXAnchor.constraint(
                equalTo: self.view.centerXAnchor),
            contentView.widthAnchor.constraint(
                equalToConstant: self.view.bounds.width - 40),
            contentView.heightAnchor.constraint(equalToConstant: 80),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func layoutcontentLabel() {
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            contentLabel.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor),
            contentLabel.centerXAnchor.constraint(
                equalTo: contentView.centerXAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }

}
