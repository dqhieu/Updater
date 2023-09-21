//
//  UpdateViewController.swift
//  Updater
//
//  Created by Dinh Quang Hieu on 21/09/2023.
//

import Foundation
import StoreKit

protocol UpdateAvailableViewDelegate: AnyObject {
  func didTapRemind()
  func didTapSkip()
}

class UpdateAvailableView: UIView {
  
  enum Constant {
    static let appStoreImageSize = CGSize(width: 80, height: 80)
    static let appStoreImageName = "AppStoreIcon"
    static let spacing: CGFloat = 24
    static let spacingTop: CGFloat = 36
    static let spacingBottom: CGFloat = 148
  }
  
  let appStoreImageView: UIImageView = {
    let view = UIImageView(image: UIImage(named: Constant.appStoreImageName)).forAutolayout()
    view.contentMode = .scaleAspectFit
    NSLayoutConstraint.activate([
      view.heightAnchor.constraint(equalToConstant: Constant.appStoreImageSize.height),
      view.widthAnchor.constraint(equalToConstant: Constant.appStoreImageSize.width)
    ])
    return view
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel().forAutolayout()
    label.text = "Update available!"
    label.font = UIFont.preferredFont(forTextStyle: .title1).bold().rounded()
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()
  
  let descriptionLabel: UILabel = {
    let label = UILabel().forAutolayout()
    label.font = UIFont.preferredFont(forTextStyle: .body).rounded()
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()
  
  let remindButton: UIButton = {
    let button = UIButton(type: .system).forAutolayout()
    button.setTitle("Remind me later", for: .normal)
    button.setTitleColor(UIColor.systemBlue, for: .normal)
    button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body).rounded()
    return button
  }()
  
  let skipButton: UIButton = {
    let button = UIButton(type: .system).forAutolayout()
    button.setTitle("Skip this version", for: .normal)
    button.setTitleColor(UIColor.systemBlue, for: .normal)
    button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body).rounded()
    return button
  }()
  
  
  private(set) lazy var buttonStackView: UIStackView = {
    let view = UIStackView().forAutolayout()
    view.axis = .horizontal
    view.alignment = .center
    view.distribution = .equalSpacing
    view.addArrangedSubview(UIView().forAutolayout())
    view.addArrangedSubview(remindButton)
    view.addArrangedSubview(UIView().forAutolayout())
    view.addArrangedSubview(skipButton)
    view.addArrangedSubview(UIView().forAutolayout())
    return view
  }()
  
  private lazy var maskLayer: CAShapeLayer = {
    self.layer.mask = $0
    return $0
  }(CAShapeLayer())
  
  override var bounds: CGRect {
    set {
      super.bounds = newValue
      maskLayer.frame = newValue
      let newPath = UIBezierPath(roundedRect: newValue, cornerRadius: UIScreen.main.displayCornerRadius).cgPath
      if let animation = self.layer.animation(forKey: "bounds.size")?.copy() as? CABasicAnimation {
        animation.keyPath = "path"
        animation.fromValue = maskLayer.path
        animation.toValue = newPath
        maskLayer.path = newPath
        maskLayer.add(animation, forKey: "path")
      } else {
        maskLayer.path = newPath
      }
    }
    get { return super.bounds }
  }
  
  weak var delegate: UpdateAvailableViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupActions()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    backgroundColor = .systemBackground
    [appStoreImageView, titleLabel, descriptionLabel, buttonStackView].forEach(addSubview)
    
    NSLayoutConstraint.activate([
      appStoreImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      appStoreImageView.topAnchor.constraint(equalTo: topAnchor, constant: Constant.spacingTop),
      titleLabel.topAnchor.constraint(equalTo: appStoreImageView.bottomAnchor, constant: Constant.spacing),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.spacing),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.spacing),
      descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constant.spacing),
      descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.spacing),
      descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.spacing),
      buttonStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constant.spacing),
      buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.spacing),
      buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.spacing),
      buttonStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constant.spacingBottom)
    ])
  }
  
  private func setupActions() {
    remindButton.addTarget(self, action: #selector(didTapRemind), for: .touchUpInside)
    skipButton.addTarget(self, action: #selector(didTapSkip), for: .touchUpInside)
  }
  
  @objc private func didTapRemind() {
    delegate?.didTapRemind()
  }
  
  @objc private func didTapSkip() {
    delegate?.didTapSkip()
  }
  
  func update(appDetail: AppDetail) {
    descriptionLabel.text =  "Newer version \(appDetail.version) is available on the App Store, update for the latest features and bug fixes."
  }
}

class UpdaterViewController: UIViewController, UpdateAvailableViewDelegate {
  
  enum Constant {
    static let spacing: CGFloat = 8
  }
  
  var window: UIWindow?
  
  private let appDetail: AppDetail
  
  init(appDetail: AppDetail) {
    self.appDetail = appDetail
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private let updateView = UpdateAvailableView().forAutolayout()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.forAutolayout()
    view.backgroundColor = UIColor.clear
  }
  
  func showUpdate() {
    updateView.delegate = self
    updateView.update(appDetail: appDetail)
    
    view.addSubview(updateView)
    updateView.isHidden = true
    
    NSLayoutConstraint.activate([
      updateView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constant.spacing),
      updateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.spacing),
      updateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.spacing),
    ])
    
    DispatchQueue.main.async { [weak self] in
      guard let this = self else { return }
      this.updateView.setGradientBorder(width: 1, colors: [UIColor.lightGray.withAlphaComponent(0.3), UIColor.lightGray, UIColor.lightGray.withAlphaComponent(0.3)])
      this.updateView.transform = CGAffineTransform(translationX: 0, y: this.updateView.frame.height)
      this.updateView.isHidden = false
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
        this.updateView.transform = CGAffineTransform.identity
        this.view.backgroundColor = UIColor.systemGray.withAlphaComponent(0.3)
      }, completion: { _ in
      })
      this.displayOverlay()
    }
  }
  
  func didTapRemind() {
    clear()
  }
  
  func didTapSkip() {
    UserDefaults.skippedVersion = appDetail.version
    clear()
  }
  
  func clear() {
    dismissOverlay()
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
      self.updateView.transform = CGAffineTransform(translationX: 0, y: self.updateView.frame.height)
      self.view.backgroundColor = UIColor.clear
    }, completion: { [weak self] _ in
      self?.dismiss(animated: false)
      self?.window?.isHidden = true
      self?.window = nil
    })
  }
  
  private func displayOverlay() {
    guard let scene = window?.windowScene else { return }
    
    let config = SKOverlay.AppConfiguration(appIdentifier: "\(appDetail.appID)", position: .bottom)
    config.userDismissible = false
    let overlay = SKOverlay(configuration: config)
    overlay.present(in: scene)
  }
  
  private func dismissOverlay() {
    guard let scene = window?.windowScene else {
      return
    }
    SKOverlay.dismiss(in: scene)
  }
}


