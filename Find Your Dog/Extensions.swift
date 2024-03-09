//
//  Extensions.swift
//  Find Your Dog
//
//  Created by Aditya Vyavahare on 09/03/24.
//

import UIKit

extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            
            guard let imageData = data else {
                print("No image data received")
                return
            }
            
            if let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}
