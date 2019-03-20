//
//  RecipeViewController.swift
//  FoodSavior
//
//  Created by Dustin Langner on 3/11/19.
//  Copyright © 2019 Dustin Langner. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {

    private let cellReuseIdentifier = "cellIdentifier"
	private let anotherCellReuseId = "favId"
	
	var collectionView: UICollectionView!
	
    var menuBar: MenuBar!
	
	var recipes: [Recipe] = []
	var recipeImages: [Recipe : UIImage] = [:]	
    var favoriteRecipes: [Recipe] = []
	var favoriteRecipeImages: [Recipe : UIImage] = [:]
    
    let tabs = ["Recipes", "Favorites"]

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.rgb(red: 125, green: 193, blue: 58)
		
		// ORDER MATTERS: This needs to be done before the table view is set up
		setupNavigationBar()
		loadFavoriteRecipes()

		self.recipes = [Recipe(data: ["id" : 1, "title" : "Testing", "readyInMinutes" : 10, "image" : ""]), Recipe(data: ["id" : 2, "title" : "Testing", "readyInMinutes" : 10, "image" : ""])]

		self.recipeImages = [self.recipes[0] : UIImage(named: "Hamburger"), self.recipes[1] : UIImage(named: "Hamburger")] as! [Recipe : UIImage]
		
		self.setupSubviews()
		self.addSubviewConstraints()
    }
	
	func setupSubviews() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
		self.collectionView.delegate = self
		self.collectionView.dataSource = self
        collectionView.isPagingEnabled = true
		
        self.collectionView.register(RecipeContainerCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
		self.collectionView.register(FavoriteContainerCell.self, forCellWithReuseIdentifier: anotherCellReuseId)
        
        self.collectionView.backgroundColor = UIColor.white
//        self.collectionView.contentInset = UIEdgeInsets(top: (self.navigationController?.navigationBar.frame.size.height)! + menuBar.frame.size.height, left: 0, bottom: 0, right: 0)
//        self.collectionView.scrollIndicatorInsets = UIEdgeInsets(top: (self.navigationController?.navigationBar.frame.size.height)! + menuBar.frame.size.height, left: 0, bottom: 0, right: 0)
		
		self.view.addSubview(self.collectionView)
	}
	
	func addSubviewConstraints() {

		self.collectionView.translatesAutoresizingMaskIntoConstraints = false
		self.collectionView.topAnchor.constraint(equalTo: self.menuBar.safeAreaLayoutGuide.bottomAnchor).isActive = true
		self.collectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
		self.collectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
		self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
	}
	
	// MARK - Navigation Bar
	
	func setupNavigationBar() {
		navigationController?.navigationBar.isTranslucent = false
		
		setTitleForIndex(index: 0)
		
		navigationItem.rightBarButtonItem = createNavBarButton(withImage: "fridge", action: #selector(handleAddFoodSelected), dimension: 50)
		
        self.menuBar = MenuBar(delegate: self)
		self.view.addSubview(menuBar)
		
		self.menuBar.translatesAutoresizingMaskIntoConstraints = false
		self.menuBar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
		self.menuBar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
		self.menuBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
		self.menuBar.heightAnchor.constraint(equalToConstant: 60).isActive = true
	}
	
	func createNavBarButton(withImage image: String, action: Selector, dimension: CGFloat) -> UIBarButtonItem {
		let button = UIButton()
		button.setImage(UIImage(named: image), for: .normal)
		button.addTarget(self, action: action, for: .touchUpInside)

		let barItem = UIBarButtonItem(customView: button)
		barItem.customView?.widthAnchor.constraint(equalToConstant: dimension).isActive = true
		barItem.customView?.heightAnchor.constraint(equalToConstant: dimension).isActive = true
		
		return barItem
	}
	
	@objc func handleAddFoodSelected() {
		let foodSelectionViewController = FoodSelectionViewController()
		foodSelectionViewController.delegate = self
		
		foodSelectionViewController.modalTransitionStyle = .crossDissolve
		foodSelectionViewController.modalPresentationStyle = .fullScreen
		
		self.present(foodSelectionViewController, animated: true, completion: nil)
	}
    
    func scrollToMenuIndex(menuIndex: IndexPath) {
        collectionView.scrollToItem(at: menuIndex, at: [], animated: true)
        setTitleForIndex(index: menuIndex.item)
    }
    
    private func setTitleForIndex(index: Int) {
		let titleLabel = UILabel()
		titleLabel.textAlignment = .center
		titleLabel.text = tabs[index]
		titleLabel.adjustsFontSizeToFitWidth = true
		titleLabel.numberOfLines = 0
		titleLabel.textColor = UIColor.white
		titleLabel.font = UIFont.systemFont(ofSize: 30)
		navigationItem.titleView = titleLabel
    }
}

extension RecipeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if tabs[indexPath.item] == "Recipes" {
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? RecipeContainerCell else {
				return UICollectionViewCell()
			}
			cell.delegate = self
			cell.recipes = self.recipes
			cell.recipeImages = self.recipeImages
			cell.tableView.reloadData()
			return cell
        } else {
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: anotherCellReuseId, for: indexPath) as? FavoriteContainerCell else {
				return UICollectionViewCell()
			}
			
			cell.delegate = self
			cell.recipes = self.favoriteRecipes
			cell.recipeImages = self.favoriteRecipeImages
			cell.tableView.reloadData()
			return cell
		}
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftConstraint?.constant = scrollView.contentOffset.x / 2
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        
        let indexPath = NSIndexPath(item: Int(index), section: 0)
        
        menuBar.collectionView.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition: [])
        
        setTitleForIndex(index: Int(index))
    }
}

extension RecipeViewController: RecipeContainerDelegate {
	func pushViewController(withRecipeId id: Int) {
		fetchRecipeDetails(withId: id)
	}
	
	func reloadFavoriteRecipes() {
		loadFavoriteRecipes()
		self.collectionView.reloadData()
	}
}

extension RecipeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - (self.navigationController?.navigationBar.frame.height)!)
    }
}

extension RecipeViewController: FoodSelectionDelegate {
	func cancelFoodSelectionPressed() {
		self.dismiss(animated: true, completion: nil)
	}
	
	func fetchRecipes(ingredients: [String], allergies: [String]) {
		let operationQueue = OperationQueue()
		let dispatchGroup = DispatchGroup()
		
		// Gets most of the recipe data
		let getRecipeData = BlockOperation {
			dispatchGroup.enter()
			RecipeAPI.getRecipes(withIngredients: ingredients, andAllergies: allergies) { [weak self] (recipes) in
				guard let strongSelf = self,
					let safeRecipes = recipes else {
						// do some error handling
						return
				}
				strongSelf.recipes = safeRecipes
				dispatchGroup.leave()
			}
			dispatchGroup.wait()
		}
		
		// From the recipe data, fetches the actual image for the given recipe
		let getRecipeImages = BlockOperation {
			for recipe in self.recipes {
				guard let imageUrl = URL(string: recipe.imageUrl) else {
					continue
				}
				dispatchGroup.enter()
				RecipeAPI.getRecipeImage(from: imageUrl, completion: { [weak self] (data, response, error) in
					if let strongSelf = self,
						let data = data,
						let image = UIImage(data: data) {
						strongSelf.recipeImages[recipe] = image
					}
					dispatchGroup.leave()
				})
			}
			dispatchGroup.wait()
		}
		
		// Updates the UI accordingly
		let updateUI = BlockOperation {
			dispatchGroup.enter()
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
			dispatchGroup.leave()
			self.dismiss(animated: true, completion: nil)
		}
		
		getRecipeImages.addDependency(getRecipeData)
		updateUI.addDependency(getRecipeImages)
		
		operationQueue.addOperation(getRecipeData)
		operationQueue.addOperation(getRecipeImages)
		operationQueue.addOperation(updateUI)
	}
	
	func fetchRecipeDetails(withId id: Int) {
		let operationQueue = OperationQueue()
		let dispatchGroup = DispatchGroup()
		
		var details: RecipeDetail? = nil
		var recipeImage: UIImage? = nil
		
		let getRecipeData = BlockOperation {
			dispatchGroup.enter()
			RecipeAPI.getRecipe(withID: id, completion: { (recipeDetails) in
				guard let recipeDetails = recipeDetails else {
					return
				}
				details = recipeDetails
				dispatchGroup.leave()
			})
			dispatchGroup.wait()
		}
		
		// From the recipe data, fetches the actual image for the given recipe
		let getRecipeImage = BlockOperation {
			dispatchGroup.enter()
			guard let details = details, let imageUrl = URL(string: details.imageUrl) else {
				return
			}
			
			RecipeAPI.getRecipeImage(from: imageUrl, completion: { (data, response, error) in
				if let data = data,
					let image = UIImage(data: data) {
					recipeImage = image
				}
				dispatchGroup.leave()
			})
			dispatchGroup.wait()
		}
		
		// Updates the UI accordingly
		let updateUI = BlockOperation {
			dispatchGroup.enter()
			DispatchQueue.main.async {
				if let details = details,
					let image = recipeImage {
					let detailsViewController = RecipeDetailsViewController(details: details, image: image)
					
					self.navigationController?.pushViewController(detailsViewController, animated: true)
				}
			}
			dispatchGroup.leave()
		}
		
		getRecipeImage.addDependency(getRecipeData)
		updateUI.addDependency(getRecipeImage)
		
		operationQueue.addOperation(getRecipeData)
		operationQueue.addOperation(getRecipeImage)
		operationQueue.addOperation(updateUI)
	}
    
    // MARK: - Favorites Integration
    
    func loadFavoriteRecipes() {
		let favoriteRecipes = FavoriteRecipeDoc.readRecipesFromDisk()
		
		var favoriteTemp: [Recipe] = []
		var favoriteImagesTemp: [Recipe : UIImage] = [:]
		
		for favRecipe in favoriteRecipes {
			let recipe = favRecipe.recipe!
			favoriteTemp.append(recipe)
			favoriteImagesTemp[recipe] = favRecipe.image!
		}
		
		self.favoriteRecipes = favoriteTemp
		self.favoriteRecipeImages = favoriteImagesTemp
    }
}
