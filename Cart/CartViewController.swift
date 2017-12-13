//
//  CartViewController.swift
//  Cart
//
//  Created by Satish Chauhan on 12/13/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet private weak var overlay: UIView! {
        didSet {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CartViewController.hideCartDetail(sender:)))
            overlay.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    @IBOutlet private weak var cartSummaryView: UIView!
    @IBOutlet private weak var cartDatilView: UIView!
    
    @IBOutlet private weak var cartDetailViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var cartSummaryViewHeightConstraint: NSLayoutConstraint!

    weak var delegate: UIViewController?
    var isVisible: Bool = false
    var isDetailVisible: Bool = false
    var summaryHeight: CGFloat = 60

    override func viewDidLoad() {
        super.viewDidLoad()

        summaryHeight = cartSummaryViewHeightConstraint.constant + 10
    }

    @objc func hideCartDetail(sender: Any?) {
        hideCartDetail()
    }

    func hideCartDetail(sender: Any?, completion: @escaping () -> Void) {
        hideCartDetail(completion: completion)
    }

    @IBAction private func toggleCartDetail(sender: Any?) {
        if isDetailVisible {
            hideCartDetail()
        } else {
            showCartDetail()
        }
    }

    private func showCartDetail() {
        if let vc = delegate as? ViewController {
            overlay.alpha = 0
            vc.cartContainerViewHeightConstraint.constant = vc.view.frame.height+100 //add buffer
            vc.cartContainerView.superview?.layoutIfNeeded()

            cartDetailViewHeightConstraint.constant = summaryHeight + 300
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.overlay.alpha = 0.4
                self?.cartSummaryView.superview?.layoutIfNeeded()
            }) { [weak self] (_) in
                self?.isDetailVisible = true
            }
        }
    }

    private func hideCartDetail(completion: (() -> Void)?=nil) {
        if let vc = delegate as? ViewController {
            cartDetailViewHeightConstraint.constant = summaryHeight

            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.overlay.alpha = 0
                self?.cartSummaryView.superview?.layoutIfNeeded()
            }) { [weak self] (_) in
                vc.cartContainerViewHeightConstraint.constant = self?.summaryHeight ?? 0
                vc.cartContainerView.superview?.layoutIfNeeded()
                self?.isDetailVisible = false

                completion?()
            }
        }
        
    }

    
}
