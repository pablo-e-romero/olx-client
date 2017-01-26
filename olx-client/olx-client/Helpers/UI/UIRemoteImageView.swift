//
//  RemoteImageView.swift
//  olx-client
//
//  Created by Pablo Romero on 1/19/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

typealias CompletionClosure = ((URL?, Error?) -> Void)

class UIRemoteImageView: UIImageView {

    var spinner: UIActivityIndicatorView?
    var currentContentURL: URL?
    
    func setContent(url: URL?) {
        
        if self.hasToRefreshContent(forNewUrl: url) {
           
            self.cleanCurrentConfiguration()
            if let url = url {
                
                self.currentContentURL = url
                if let image = self.cachedImage(forRemoteUrl: url) {
                    self.image = image
                } else {
                    
                    self.presentLoadingMode()

                    let localUrl = self.localCachedImageUrl(forRemoteUrl: url)
                    
                    NetworkHelper.downloadContent(fromUrl: url, to: localUrl) { (remoteUrl: URL, localUrl: URL?, error: Error?) in
                        DispatchQueue.main.async {
                            self.removeLoadingMode()
                            if error != nil {
                                self.presentErrorMode()
                            } else {
                                if let currentUrl = self.currentContentURL, currentUrl == url {
                                    print("downloaded \(url) to \(localUrl)")
                                    self.image = self.cachedImage(forRemoteUrl: url)!
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func hasToRefreshContent(forNewUrl newUrl: URL?) -> Bool {
        if self.image == nil {
            return true
        } else {
            if let currentURL = self.currentContentURL {
                return currentURL != newUrl
            } else {
                return true
            }
        }
    }
    
    // MARK: - Cache
    
    private func cachedImage(forRemoteUrl url: URL) -> UIImage? {
        let localUrl = self.localCachedImageUrl(forRemoteUrl: url)
        if FileSystemHelper.sharedInstance.existFile(atUrl: localUrl) {
            let path = localUrl.path
            return UIImage(contentsOfFile: path)
        } else {
            return nil
        }
    }
    
    private func localCachedImageUrl(forRemoteUrl url: URL) -> URL {
        var localURL = FileSystemHelper.cachesUrl()
        localURL.appendPathComponent(url.md5Hash())
        return localURL
    }
 
    
    // MARK: - States
    
    private func cleanCurrentConfiguration() {
        self.currentContentURL = nil
        self.image = nil
        self.removeLoadingMode()
    }
    
    private func presentLoadingMode() {
        self.image = nil
        
        if self.spinner == nil
        {
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            self.addSubview(spinner)
           
            spinner.startAnimating()
            spinner.center = CGPoint(x: self.bounds.size.width / 2.0,
                                     y: self.bounds.size.height / 2.0)
            
            spinner.autoresizingMask = [.flexibleBottomMargin,
                                        .flexibleLeftMargin,
                                        .flexibleRightMargin,
                                        .flexibleTopMargin]
            
            self.spinner = spinner
        }
    }
    
    private func removeLoadingMode() {
        if let spinner = self.spinner {
            spinner.removeFromSuperview()
        }
        self.spinner = nil
    }
    
    private func presentErrorMode() {
        self.image = nil
        self.removeLoadingMode()
    }
    
}
