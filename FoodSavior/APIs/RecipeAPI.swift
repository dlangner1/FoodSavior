//
//  RecipeAPI.swift
//  FoodSavior
//
//  Created by Dustin Langner on 3/13/19.
//  Copyright © 2019 Dustin Langner. All rights reserved.
//

import UIKit

class RecipeAPI: NSObject {
	
	static func getRecipes(withIngredients ingredients: [String], andAllergies allergies: [String], completion: @escaping (_ result: [Recipe]?) -> Void) {
		let baseQueryString = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/search?"
		
		let intolerancesParam = allergies.count > 0 ? "intolerances=\(allergies.joined(separator: "%2C+"))&" : ""
		let numberOfResultsParam = "number=20&"
		let instructionsParam = "instructionsRequired=true&"
		let ingredientsParam = "query=" + ingredients.joined(separator: "%2C+")
		
		let queryStringWithParams = baseQueryString + intolerancesParam + numberOfResultsParam + instructionsParam + ingredientsParam

		guard let request = createRequest(withUrlString: queryStringWithParams) else {
			// couldn't properly create the request
			return
		}
		
		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			guard let data = data else {
				// handle error
				return
			}
			
			print(response!)
			
			do {
				let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
				guard let safeJson = json, let results = safeJson["results"] as? [[String : Any]] else {
					return
				}
				
				// map all the [String : Any] objects to a Recipe Object
				let recipes = results.map({ (recipeData) -> Recipe in
					return Recipe(data: recipeData)
				})
				
				// SUCCESS
				completion(recipes)
			} catch {
				print("json seralization failed")
				completion(nil)
			}
		}

		task.resume()
	}
	
	static func getRecipe(withID id: Int, completion: @escaping (_ result: RecipeDetail?) -> Void) {
		let queryString = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/\(id)/information?includeNutrition=true"
	
		guard let request = createRequest(withUrlString: queryString) else {
			// couldn't properly create the request
			return
		}
		
		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			guard let data = data else {
				// handle error
				return
			}

			do {
				let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
				guard let safeJson = json else {
					return
				}
				let recipeDetail = RecipeDetail(data: safeJson)
				
				completion(recipeDetail)
			} catch {
				print("json seralization failed")
				completion(nil)
			}
		}
		
		task.resume()
	}
	
	static func getRecipeImage(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
		URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
	}
	
	
	private static func createRequest(withUrlString urlString: String) -> URLRequest? {
		guard let url = URL(string: urlString) else {
			// handle errors
			return nil
		}
		
		var keys: NSDictionary?
		
		if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
			keys = NSDictionary(contentsOfFile: path)
		}
		
		guard let dict = keys,
			let apiKey = dict["X-RapidAPI-Key"] as? String else {
				return nil
		}
		
		var request = URLRequest(url: url)
		request.addValue(apiKey, forHTTPHeaderField: "X-RapidAPI-Key")
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpMethod = "GET"
		
		return request
	}
}
