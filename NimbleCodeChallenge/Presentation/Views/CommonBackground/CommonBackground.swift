//
//  CommonBackground.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 8/29/24.
//

import SwiftUI
import Kingfisher

enum BackgroundImageSource {
    case asset(name: String)
    case url(URL)
}

struct CommonBackground: View {
    var backgroundImageSource: BackgroundImageSource = .asset(name: Assets.Images.commonBg)
    
    var body: some View {
        Group {
            switch backgroundImageSource {
            case .asset(let name):
                Image(name)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .url(let url):
                KFImage(url)
                    .setProcessor(DownsamplingImageProcessor(size: UIScreen.main.bounds.size))
                    .loadDiskFileSynchronously()
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .edgesIgnoringSafeArea([.all])
    }
}
