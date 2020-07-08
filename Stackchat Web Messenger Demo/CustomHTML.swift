//
//  CustomHTML.swift
//  Stackchat Web Messenger Demo
//
//  Created by Parth Mehta on 8/7/20.
//  Copyright © 2020 Parth Mehta. All rights reserved.
//

import Foundation

func getCustomHTML(appId: String)-> String {
    return """
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
        <title>Stackchat Demo</title>
        <style>
          #root {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
          }
        </style>
        
        <script>
                 !function(e,t,n,r){function s(){try{var e;if((e="string"==typeof this.response?JSON.parse(this.response):this.response).url){var n=t.getElementsByTagName("script")[0],r=t.createElement("script");r.async=!0,r.src=e.url,n.parentNode.insertBefore(r,n)}}catch(e){}}var o,p,a,c=[],i=[];e[n]={init:function(){o=arguments;var e={then:function(t){return i.push({type:"t",next:t}),e},catch:function(t){return i.push({type:"c",next:t}),e}};return e},on:function(){c.push(arguments)},render:function(){p=arguments},destroy:function(){a=arguments}},e.__onWebMessengerHostReady__=function(t){if(delete e.__onWebMessengerHostReady__,e[n]=t,o)for(var r=t.init.apply(t,o),s=0;s<i.length;s++){var u=i[s];r="t"===u.type?r.then(u.next):r.catch(u.next)}p&&t.render.apply(t,p),a&&t.destroy.apply(t,a);for(s=0;s<c.length;s++)t.on.apply(t,c[s])};var u=new XMLHttpRequest;u.addEventListener("load",s),u.open("GET","https://assets.au.stackchat.com/sdk/web-messenger/2.1.29/loader.json",!0),u.responseType="json",u.send()}(window,document,"stackchat");
        </script>
    </head>
        
    <body>
        <div id="root"></div>
    <script>
    window.setTimeout(() => {
    stackchat.init({
    appId: "\(appId)",
    embedded: true
    })
    })
    
    stackchat.render(document.getElementById("root"))
    </script>
    </body>

    </html>
"""
}

extension String {
    func escapeString() -> String {
        var newString = self.replacingOccurrences(of: "\"", with: "\"\"")
        if newString.contains(",") || newString.contains("\n") {
            newString = String(format: "\"%@\"", newString)
        }

        return newString
    }
}
