//
//  StartUp_View.swift
//  TryHomeCare
//
//  Created by appsDev on 04/11/19.
//  Copyright © 2019 Paras Technologies. All rights reserved.
//

import SwiftUI
import Combine
import UIKit

struct StartUp_View: View {
    var body: some View {
        ZStack {
            Image("startup_bg").resizable()
            .aspectRatio(contentMode: .fill).edgesIgnoringSafeArea(.all)
            VStack.init(alignment: .center, spacing: 20) {
                Spacer()
                Image.init("logo_white").padding(.top, 120)
                Spacer()
                StartUp_SignIn_Pager()
                Spacer()
                Button.init(action: {
                    print("SIGN UP Taped")
                }) {
                    Text("Sign Up")
                    .fontWeight(.bold)
                    .font(.body)
                    .foregroundColor(.white)
                }.frame(width: 310, height: 53, alignment: .center)
                    .background(Color.init(red: 10/255, green: 182/255, blue: 231/255))
                    .cornerRadius(8)
                    .padding(.bottom, 20)
                Button.init(action: {
                    print("Try without an Account Taped")
                }) {
                    Text("Try without an Account")
                    .fontWeight(.bold)
                    .font(.body)
                    .foregroundColor(.white)
                }.frame(width: 310, height: 53, alignment: .center)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white, lineWidth: 1)
                )
                Spacer()
                StartUp_SignIn_Button().padding(.bottom, 30)
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
    }
}
struct StartUp_SignIn_Button: View {
    var body: some View {
        HStack {
            Spacer()
            Button.init(action: {
                print("SIGN IN Taped")
            }) {
                Text("SIGN IN")
                .fontWeight(.bold)
                .font(.body)
                .foregroundColor(.white)
                .padding()
            }.frame(width: 150, height: 50, alignment: .center)
        }
    }
}
struct StartUp_SignIn_Pager : View {
    let limit: Double = 15
    let step: Double = 0.3

    @State var pages: [Page] = (0...3).map { i in
        Page(body: MockData.contentStrings[i])
    }

    @State var currentIndex = 0
    @State var nextIndex = 1

    @State var progress: Double = 0
    @State var isAnimating = false

    static let timerSpeed: Double = 0.01
    @State var timer = Timer.publish(every: timerSpeed, on: .current, in: .common).autoconnect()
    var body: some View {
        VStack {
            ZStack {
                PageView(page: pages[currentIndex])
                    .offset(x: -CGFloat(pow(2, self.progress)))
                PageView(page: pages[nextIndex])
                    .offset(x: CGFloat(pow(2, (self.limit - self.progress))))
            }.edgesIgnoringSafeArea(.vertical)
                .onReceive(self.timer) { _ in
                    if !self.isAnimating {
                        return
                    }
                    self.refreshAnimatingViews()
            }
            PageControl.init(numberOfPages: 4, currentPage: $currentIndex).padding(.all, 0)
        }
    }
    func refreshAnimatingViews() {
        progress += step
        if progress > 2*limit {
            isAnimating = false
            progress = 0
            currentIndex = nextIndex
            if nextIndex + 1 < pages.count {
                nextIndex += 1
            } else {
                nextIndex = 0
            }
        }
    }
}
struct PageControl: UIViewRepresentable {
    var numberOfPages: Int
    @Binding var currentPage: Int

    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        control.addTarget(
            context.coordinator,
            action: #selector(Coordinator.updateCurrentPage(sender:)),
            for: .valueChanged)

        return control
    }

    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // This is where old paradigm located
    class Coordinator: NSObject {
        var control: PageControl

        init(_ control: PageControl) {
            self.control = control
        }

        @objc func updateCurrentPage(sender: UIPageControl) {
            control.currentPage = sender.currentPage
        }
    }
}
struct PageView: View {
    var page: Page
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Text(page.body).font(.body).lineLimit(nil).foregroundColor(.white).multilineTextAlignment(.center)
        }.padding(.leading, 60).padding(.trailing, 60)
    }
}
struct Page {
    var body: String
}
struct MockData {
    static let contentStrings = [
        "Step 1. Break off a branch holding a few grapes and lay it on your plate.",
        "Step 2. Put a grape in your mouth whole.",
        "Step 3. Deposit the seeds into your thumb and first two fingers.",
        "Step 4. Place the seeds on your plate."
    ]
}


struct StartUp_View_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            StartUp_View()
            StartUp_SignIn_Button().previewLayout(.sizeThatFits)
            StartUp_SignIn_Pager().previewLayout(.sizeThatFits)
        }
    }
}
