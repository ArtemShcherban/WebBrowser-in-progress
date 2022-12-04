//
//  WebBrowserView.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 03.12.2022.
//

import UIKit

final class WebBrowserView: UIView {
    lazy var cancelButton = UIButton(type: .system)
    lazy var toolbar = Toolbar()
    lazy var addressBarScrollView = UIScrollView()
    lazy var addressBarStackView = UIStackView()
    lazy var keyboardBackgroundView = UIView()
    
    var addressBarScrollViewBottomConstraint: NSLayoutConstraint?
    var keyboardBackgroundViewBottomConstraint: NSLayoutConstraint?
    var toolbarBottomConstraint: NSLayoutConstraint?
    
    // AddressBar animation constants
    let addressBarWidthOffset: CGFloat = -48
    let addressBarContainerHidingWidthOffset: CGFloat = -200
    let addressBarStackViewSidePadding: CGFloat = 24
    let addressBarStackViewSpacing: CGFloat = 4
    let addressBarHiddingCenterOffset: CGFloat = 30
    
    // AddressBar expanding and collapsing constants
    let addressBarExpandingHalfwayBottomOffset: CGFloat = -22
    let addressBarExpandingFullyBottomOffset: CGFloat = -38
    let addressBarCollapsingHalfwayBottomOffset: CGFloat = -8
    let addressBarCollapsingFullyBottomOffset: CGFloat = 35 // 20
    
    // Toolbar expanding and collapsing constants
    let toolBarExpandingHalfwayBottomOffset: CGFloat = 40
    let toolBarExpandingFullyBottomOffset: CGFloat = 0
    let toolBarCollapsingHalfwayBottomOffset: CGFloat = 30
    let toolBarCollapsingFullyBottomOffset: CGFloat = 80
    
    var addressBarPageWidth: CGFloat {
        frame.width + addressBarWidthOffset + addressBarStackViewSpacing
    }
    
    var addressBars: [AddressBar] {
        addressBarStackView.arrangedSubviews as? [AddressBar] ?? []
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAddressBar(isHidden: Bool, withDelegate delegate: AddressBarDelegate) {
        let addressBar = AddressBar()
        addressBar.delegate = delegate
        addressBarStackView.addArrangedSubview(addressBar)
        addressBar.translatesAutoresizingMaskIntoConstraints = false
        
        addressBar.widthAnchor.constraint(
            equalTo: self.widthAnchor,
            constant: self.addressBarWidthOffset
        ).isActive = true
        
        if isHidden {
            addressBar.containerViewWidthConstraint?.constant = addressBarContainerHidingWidthOffset
            addressBar.containerView.alpha = 0
        }
    }
    
    func cancelButtonHidden(_ isHidden: Bool) {
        cancelButton.alpha = isHidden ? 0 : 1
    }
}

private extension WebBrowserView {
    func setupView() {
        backgroundColor = UIColor(white: 0.97, alpha: 1)
        setupToolbar()
        setupAddressBarScrollView()
        setupAddressBarStackView()
        setupKeyboardBackgroundView()
        setupCancelButton()
    }
    
    func setupToolbar() {
        addSubview(toolbar)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        toolbarBottomConstraint = toolbar.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        guard let toolbarBottomConstraint else { return }
        
        NSLayoutConstraint.activate([
            toolbar.heightAnchor.constraint(equalToConstant: 100),
            toolbar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            toolbarBottomConstraint
        ])
    }
    
    func setupAddressBarScrollView() {
        addressBarScrollView.backgroundColor = .yellow
        addressBarScrollView.clipsToBounds = false
        addressBarScrollView.showsVerticalScrollIndicator = false
        addressBarScrollView.showsHorizontalScrollIndicator = false
        addressBarScrollView.decelerationRate = .fast
        addSubview(addressBarScrollView)
        addressBarScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        addressBarScrollViewBottomConstraint = addressBarScrollView.bottomAnchor.constraint(
            equalTo: self.safeAreaLayoutGuide.bottomAnchor,
            constant: addressBarExpandingFullyBottomOffset
        )
        guard let addressBarScrollViewBottomConstraint else { return }
        
        NSLayoutConstraint.activate([
            addressBarScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            addressBarScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            addressBarScrollViewBottomConstraint
        ])
    }
    
    func setupAddressBarStackView() {
        addressBarStackView.backgroundColor = .systemRed
        addressBarStackView.clipsToBounds = false
        addressBarStackView.axis = .horizontal
        addressBarStackView.alignment = .fill
        addressBarStackView.distribution = .fill
        addressBarStackView.spacing = addressBarStackViewSpacing
        addressBarScrollView.addSubview(addressBarStackView)
        addressBarStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addressBarStackView.leadingAnchor.constraint(
                equalTo: addressBarScrollView.leadingAnchor,
                constant: addressBarStackViewSidePadding
            ),
            addressBarStackView.trailingAnchor.constraint(
                equalTo: addressBarScrollView.trailingAnchor,
                constant: -addressBarStackViewSidePadding
            ),
            addressBarStackView.topAnchor.constraint(equalTo: addressBarScrollView.topAnchor),
            addressBarStackView.bottomAnchor.constraint(equalTo: addressBarScrollView.bottomAnchor),
            addressBarStackView.heightAnchor.constraint(equalTo: addressBarScrollView.heightAnchor)
        ])
    }
    
    func setupKeyboardBackgroundView() {
        keyboardBackgroundView.backgroundColor = .keyboardGray
        keyboardBackgroundView.isHidden = true
        insertSubview(keyboardBackgroundView, belowSubview: toolbar)
        keyboardBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        keyboardBackgroundViewBottomConstraint = keyboardBackgroundView.bottomAnchor.constraint(
            equalTo: self.safeAreaLayoutGuide.bottomAnchor
        )
        guard let keyboardBackgroundViewBottomConstraint else { return }
        
        NSLayoutConstraint.activate([
            keyboardBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            keyboardBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            keyboardBackgroundView.heightAnchor.constraint(equalToConstant: 72),
            keyboardBackgroundViewBottomConstraint
        ])
    }
    
    func setupCancelButton() {
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        cancelButton.alpha = 0
        cancelButton.setTitle("Cancel", for: .normal)
        addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24).isActive = true
    }
}
