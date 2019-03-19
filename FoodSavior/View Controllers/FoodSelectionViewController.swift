//
//  FoodSelectionViewController.swift
//  FoodSavior
//
//  Created by Dustin Langner on 3/11/19.
//  Copyright © 2019 Dustin Langner. All rights reserved.
//

import UIKit

protocol FoodSelectionDelegate: AnyObject {
	func cancelFoodSelectionPressed()
}

class FoodSelectionViewController: UIViewController {
	weak var delegate: FoodSelectionDelegate?
	
	var cancelButton: UIButton!
	var titleLabel: UILabel!
	var foodToUseTextField: UITextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.green

		setupSubviews()
		addSubviewConstraints()
    }
	
	func setupSubviews() {
		self.cancelButton = UIButton(frame: .zero)
		self.cancelButton.setTitle("Cancel", for: .normal)
		self.cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
		self.cancelButton.sizeToFit()
		
		self.titleLabel = UILabel(frame: .zero)
		self.titleLabel.text = "Input the food items you wish to use!"
		self.titleLabel.textColor = UIColor.white
		self.titleLabel.font = self.titleLabel.font.withSize(30)
		self.titleLabel.lineBreakMode = .byWordWrapping
		self.titleLabel.numberOfLines = 0
		self.titleLabel.textAlignment = .center
		
		self.foodToUseTextField = UITextField(frame: .zero)
		self.foodToUseTextField.underlined()
		self.foodToUseTextField.backgroundColor = UIColor.red
		// config text field
		
		self.view.addSubview(cancelButton)
		self.view.addSubview(foodToUseTextField)
		self.view.addSubview(titleLabel)
	}
	
	func addSubviewConstraints() {
		self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
		self.cancelButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
		self.cancelButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
		self.cancelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
		
		self.foodToUseTextField.translatesAutoresizingMaskIntoConstraints = false
		self.foodToUseTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
		self.foodToUseTextField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
		self.foodToUseTextField.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
		self.foodToUseTextField.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
		self.foodToUseTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
		
		self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
		self.titleLabel.bottomAnchor.constraint(equalTo: self.foodToUseTextField.topAnchor, constant: -16).isActive = true
		self.titleLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
		self.titleLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
		self.titleLabel.topAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
	}
	
	@objc func cancelPressed() {
		guard let delegate = delegate else {
			return
		}
		delegate.cancelFoodSelectionPressed()
	}
}

extension FoodSelectionViewController: UITextFieldDelegate {
	
	
	
	
	
}
