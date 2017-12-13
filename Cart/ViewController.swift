//
//  ViewController.swift
//  Cart
//
//  Created by Satish Chauhan on 12/13/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate           = self
            tableView.dataSource         = self
            tableView.rowHeight          = UITableViewAutomaticDimension
            tableView.tableFooterView    = UIView(frame: CGRect.zero)
            tableView.estimatedRowHeight = 36

        }
    }

    @IBOutlet weak var cartContainerView: UIView!
    @IBOutlet weak var cartContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var cartContainerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableViewBottomConstraint: NSLayoutConstraint!

    private var rows = [String]()
    var cartVC: CartViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for n in 1...100 {
            rows.append("Row \(n)")
        }

        cartContainerViewBottomConstraint.constant = -cartVC.summaryHeight
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let vc = segue.destination as? CartViewController {
            cartVC = vc
            vc.delegate = self
        }
    }

    @IBAction private func showCart(sender: Any?) {
        if cartVC.isVisible {
            hideCart()
        } else {
            showCart()
        }
    }

    private func showCart() {
        cartContainerViewBottomConstraint.constant = 0
        tableViewBottomConstraint.constant = cartVC.summaryHeight

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.cartContainerView.superview?.layoutIfNeeded()
        }) {  [weak self] (_) in
            self?.cartVC.isVisible = true
        }
    }

    private func hideCart() {
        func hideCartAnimated() {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.cartContainerView.superview?.layoutIfNeeded()
            }) {  [weak self] (_) in
                self?.cartVC.isVisible = false
            }
        }

        cartContainerViewBottomConstraint.constant = -cartVC.summaryHeight
        tableViewBottomConstraint.constant = 0

        if cartVC.isDetailVisible {
            cartVC.hideCartDetail(sender: self)
            hideCartAnimated()
        } else {
            hideCartAnimated()
        }
    }

    func showCartDetail() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.cartContainerView.superview?.layoutIfNeeded()
        }) {  [weak self] (_) in
            if let isVisible = self?.cartVC.isVisible {
                self?.cartVC.isVisible = !isVisible
            }
        }
    }

}

extension ViewController: UITableViewDelegate {

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        cell.textLabel?.text = rows[indexPath.row]

        return cell
    }

}
