//
//  ContentView.swift
//  Stackchat Web Messenger Demo
//
//  Created by Parth Mehta on 7/7/20.
//  Copyright © 2020 Parth Mehta. All rights reserved.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @State var webMessengerConfig: WebMessengerConfig? = nil
    @State private var appId = ""
    
    private func getWebMessengerConfig() {
        let url = URL(string: "https://api.io.au.stackchat.com/config/apps/\(appId)/config")!
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                print("error: \(String(describing: error))")
                return
            }
            
            guard let content = data else {
                print("No data")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: content)
            let jsonObject = json as! [String: [String: Any]]
            
            guard let _data = jsonToNSData(json:jsonObject["config"]!["webMessengerConfig"] as AnyObject) else {
                print("No config")
                return
            }
            
            let parsedData = try? JSONDecoder().decode(
                WebMessengerConfig.self,
                from: _data
            )
            
            self.webMessengerConfig = parsedData
        }
        task.resume()
    }
    
    var body: some View {
        let binding = Binding<String>(
            get:{self.appId},
            set:{ self.appId = $0 }
        )
        
        return NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .leading) {
                    Rectangle().fill(Color.yellow.opacity(0)).frame(width: nil, height: 20)
                    Text("Enter your bot's App ID:")
                    TextField("a1b2c3d4e5f6g7h8i9j0", text: binding)
                        .accentColor(Color(hex: "#8C1AFF"))
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "#8C1AFF"), lineWidth: 2)
                    )
                    Rectangle().fill(Color.white).frame(width: nil, height: 10)
                    Button(action: {
                        self.getWebMessengerConfig()
                    }) {
                        Text("Update")
                            .bold()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .foregroundColor(Color.white)
                            .padding()
                          
                    }
                        .background(Color(hex: "#8C1AFF"))
                        .cornerRadius(6)
                    Spacer()
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
                
                // Floating Button
                WebMessengerLauncher(appId: appId, iconUrl: webMessengerConfig?.buttonIconURL)
            }
            .navigationBarTitle("Stackchat Demo")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().colorScheme(.light)
    }
}

struct WebMessengerLauncher: View {
    private var icon: String?
    private var appId: String?
    @State var isPresented = false
    
    init(appId: String?, iconUrl: String?) {
        self.appId = appId
        icon = iconUrl
    }
    
    @ViewBuilder
    var body: some View {
        if icon != nil {
            ButtonIcon(urlString: icon!, width: nil, height: nil)
                .onTapGesture {
                    self.isPresented = true
            }.sheet(isPresented: $isPresented) {
//                WebView()
                WebView(customHTML: getCustomHTML(appId: self.appId!))
            }
        } else {
            Circle()
              .fill(Color(hex: "#8C1AFF"))
              .frame(width: 56, height: 56)
              .padding(16)
        }
    }
}

// https://stackoverflow.com/a/56874327/8014018
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

func jsonToNSData(json: AnyObject) -> Data?{
    do {
        return try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
    } catch let myJSONError {
        print(myJSONError)
    }
    return nil
}

struct WebView: UIViewRepresentable {
    let customHTML: String
    
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(customHTML, baseURL: nil)
//        uiView.load(URLRequest(url: URL(string: "https://www.apple.com")!))
    }
}
