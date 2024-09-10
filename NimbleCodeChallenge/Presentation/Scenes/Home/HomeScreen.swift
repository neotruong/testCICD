//
//  HomeScreen.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 8/29/24.
//

import SwiftUI

struct HomeScreen: View {
    @ObservedObject var input: HomeViewModel.Input
    @ObservedObject var output: HomeViewModel.Output
    @EnvironmentObject var router: MainRouterViewModel
    private var cancelBag: CancelBag = CancelBag()

    @State private var viewHeight: CGFloat = 1
    var onTakingSurvey: (() -> Void)?
    var onGetListSurveyError: (() -> Void)?
    var didLogoutAction: (() -> Void)?

    init(viewModel: HomeViewModel, 
         onTakingSurvey: (() -> Void)?,
         onGetListSurveyError: (() -> Void)?,
         didLogoutAction: (() -> Void)?) {
        let input = HomeViewModel.Input()
        self.output = viewModel.transform(input)
        self.input = input
        self.onTakingSurvey = onTakingSurvey
        self.onGetListSurveyError = onGetListSurveyError
        self.didLogoutAction = didLogoutAction
    }

    var body: some View {
        @State var totalPages = output.surveyData.listSurvey.count
        let currentImage: BackgroundImageSource = loadImage(surveyData: output.surveyData.listSurvey,
                                                            currentPage: output.currentPage)

        ZStack {
            if totalPages > 0 || !output.didFirstLoad {
                CommonBackground(backgroundImageSource: currentImage)
                    .overlay {
                        ThemeManager.shared.color.overlayBackground
                    }
                    .ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        HomeCardView(
                            dateText: getFormattedDate(),
                            titleText: getTitleText(),
                            imageName: Assets.Images.logo,
                            onAvatarTap: {
                                self.didLogoutAction?()
                            }
                        )
                        .padding(20)
                        .padding(.top, UIApplication.shared.keyWindow?.safeAreaInsets.top)

                        Spacer()

                        PageControl(currentPage: $output.currentPage, numberOfPages: totalPages)

                        TabView(selection: $output.currentPage) {
                            ForEach(0..<totalPages, id: \.self) { index in
                                let surveyItem = output.surveyData.listSurvey[index]

                                VStack(spacing: 12) {
                                    MText(
                                        text: surveyItem.name,
                                        font: MFont.customFont(.bold, size: 28),
                                        color: ThemeManager.shared.color.primaryWhite
                                    )
                                    .multilineTextAlignment(.center)

                                    MText(
                                        text: surveyItem.description,
                                        font: MFont.customFont(.regular, size: 17),
                                        color: ThemeManager.shared.color.paddingButtonWhite
                                    )
                                    .multilineTextAlignment(.center)
                                    .frame(minHeight: 50)

                                    MButton(title: MString.Home.takeSurvey, buttonAction: {
                                        self.onTakingSurvey?()
                                    })
                                    .frame(height: 50)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 20)
                                .padding(.top, 26)
                                .padding(.bottom, 20)
                                .background {
                                    GeometryReader { geometry in
                                        Color.clear.preference(
                                            key: TabViewHeightPreference.self,
                                            value: geometry.frame(in: .local).height
                                        )
                                    }
                                }
                                .tag(index)
                            }
                        }
                        .frame(height: viewHeight)
                        .padding(.bottom, UIApplication.shared.keyWindow?.safeAreaInsets.bottom)
                        .onPreferenceChange(TabViewHeightPreference.self) { newHeight in
                            DispatchQueue.main.async {
                                self.viewHeight = newHeight
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .refreshable {
                    input.onRefresh.send(())
                }
            } else {
                LazyLoadHome()
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    let threshold: CGFloat = 50
                    if value.translation.width > threshold {
                        withAnimation {
                            if output.currentPage > 0 {
                                output.currentPage -= 1
                            }
                        }
                    } else if value.translation.width < -threshold {
                        withAnimation {
                            if output.currentPage < totalPages - 1 {
                                output.currentPage += 1
                            }
                        }
                    }
                }
        )
        .onAppear {
            input.onAppear.send(())
        }
        .onReceive(output.onError) { message in
            self.onGetListSurveyError?()
            self.router.triggerAlert(message: message)
        }

        .hideNavigationBar()
    }

    private func loadImage(surveyData: [SurveyItem], currentPage: Int) -> BackgroundImageSource {
        if surveyData.isEmpty {
            if let cachedURL = output.cacheImageURL.first {
                if let validURL = URL(string: cachedURL) {
                    return .url(validURL)
                } else {
                    return .asset(name: Assets.Images.commonBg)
                }
            } else {
                return .asset(name: Assets.Images.commonBg)
            }
        } else {
            let currentImageURL = surveyData[currentPage].getURL()

            if let validURL = currentImageURL {
                return .url(validURL)
            } else {
                return .asset(name: Assets.Images.commonBg)
            }
        }
    }

    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd"
        return dateFormatter.string(from: Date()).uppercased()
    }


    func getTitleText() -> String {
        return "Today"
    }
}

private struct TabViewHeightPreference: PreferenceKey {
    static var defaultValue: CGFloat = 150

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
