//
//  TabBarController.swift
//  Find Your Dog
//
//  Created by Aditya Vyavahare on 09/03/24.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
            super.viewDidLoad()
            
            // Create view controllers for the Breeds and Favourites screens
            let breedsViewController = BreedListViewController()
            let favouritesViewController = FavouritesViewController()
            
            // Set titles for the tab items
            breedsViewController.title = "Breeds"
            favouritesViewController.title = "Favourites"
            
            // Set tab bar icons if needed
            breedsViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
            favouritesViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
            
            // Embed view controllers in navigation controllers if needed
            let breedsNavigationController = UINavigationController(rootViewController: breedsViewController)
            let favouritesNavigationController = UINavigationController(rootViewController: favouritesViewController)
            
            // Set view controllers for the tab bar controller
            viewControllers = [breedsNavigationController, favouritesNavigationController]
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
