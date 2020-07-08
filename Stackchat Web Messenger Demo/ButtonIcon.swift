//
//  ButtonIcon.swift
//  Stackchat Web Messenger Demo
//
//  Created by Parth Mehta on 8/7/20.
//  Copyright © 2020 Parth Mehta. All rights reserved.
//

import SwiftUI

struct ButtonIcon: View {
    @ObservedObject var urlImageModel: UrlImageModel
    @State var width:CGFloat = 56
    @State var height:CGFloat = 56
    
    init(urlString: String, width: CGFloat?, height: CGFloat?) {
        urlImageModel = UrlImageModel(urlString: urlString)
        self.width = width ?? 56
        self.height = height ?? 56
    }
    
    var body: some View {
        Image(uiImage: urlImageModel.image ?? ButtonIcon.defaultImage!)
        .resizable()
        .scaledToFit()
        .frame(width: width, height: height)
        .padding(16)
    }
    
    static var defaultImage = UIImage(systemName: "photo")
}

class UrlImageModel: ObservableObject {
    @Published var image: UIImage?
    var urlString: String?
    
    init(urlString: String?) {
        self.urlString = urlString
        loadImage()
    }
    
    func loadImage() {
        loadImageFromUrl()
    }
    
    func loadImageFromUrl() {
        guard let urlString = urlString else {
            return
        }
        
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: getImageFromResponse(data:response:error:))
        task.resume()
    }
    
    
    func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            print("Error: \(error!)")
            return
        }
        guard let data = data else {
            print("No data found")
            return
        }
        
        DispatchQueue.main.async {
            guard let loadedImage = UIImage(data: data) else {
                return
            }
            self.image = loadedImage
        }
    }
}

//struct ButtonIcon_Previews: PreviewProvider {
//    static var previews: some View {
//        ButtonIcon(urlString: nil, width: nil, height: nil)
//    }
//}
