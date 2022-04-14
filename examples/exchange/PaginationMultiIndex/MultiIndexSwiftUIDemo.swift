//
//  MultiIndexSwiftUIDemo.swift
//  Examples
//
//  Created by Vladislav Fitc on 14/04/2022.
//

import Foundation
import SwiftUI
import InstantSearchCore
import InstantSearchSwiftUI
import SDWebImageSwiftUI

struct MultiIndexSwiftUIDemo: PreviewProvider {
  
  class Controller {
    
    let demoController: MultiIndexDemoController
    let queryInputController: QueryInputObservableController
    let suggestionsHitsController: HitsObservableController<QuerySuggestion>
    let productsHitsController: HitsObservableController<Hit<StoreItem>>
    
    init() {
      demoController = .init()
      queryInputController = .init()
      suggestionsHitsController = .init()
      productsHitsController = .init()
      demoController.queryInputConnector.connectController(queryInputController)
      demoController.suggestionsHitsConnector.connectController(suggestionsHitsController)
      demoController.productsHitsConnector.connectController(productsHitsController)
    }
    
  }
  
  struct ContentView: View {
    
    @ObservedObject var queryInputController: QueryInputObservableController
    @ObservedObject var suggestionsHitsController: HitsObservableController<QuerySuggestion>
    @ObservedObject var productsHitsController: HitsObservableController<Hit<StoreItem>>
    
    var body: some View {
      VStack {
        HStack {
          Text("Popular searches")
            .font(.title3)
          Spacer()
        }
        ScrollView(.horizontal) {
          let hitsCount = suggestionsHitsController.hits.count
          LazyHStack {
            ForEach(0..<hitsCount, id: \.self) { index in
              cellForSuggestion(atIndex: index)
            }
          }
        }
        .frame(maxHeight: 50)
        HStack {
          Text("Products")
            .font(.title3)
          Spacer()
        }
        ScrollView(.horizontal) {
          let hitsCount = productsHitsController.hits.count
          LazyHStack {
            ForEach(0..<hitsCount, id: \.self) { index in
              cellForProduct(atIndex: index)
            }
          }
        }
        .frame(maxHeight: 200)
        Spacer()
      }
      .padding()
      .searchable(text: $queryInputController.query)
      .background(Color(.systemGray6))
    }
    
    func cellForSuggestion(atIndex index: Int) -> some View {
      let suggestion = suggestionsHitsController.hits[index]!
      
      return Text(highlightedString: HighlightedString(string: suggestion.highlighted!)) { string in
        Text(string)
          .foregroundColor(Color(.tintColor))
      }
      .font(.headline)
      .padding(.horizontal, 10)
      .padding(.vertical, 5)
      .background(Color.white)
      .cornerRadius(10)
      .onAppear {
        suggestionsHitsController.notifyAppearanceOfHit(atIndex: index)
      }
    }
    
    func cellForProduct(atIndex index: Int) -> some View {
      let product = productsHitsController.hits[index]!
      return VStack {
        WebImage(url: product.object.images.first!)
          .resizable()
          .indicator(.activity)
          .scaledToFit()
          .clipped()
          .frame(width: 100, height: 100, alignment: .center)
        if let highlightedTitle = product.hightlightedString(forKey: "name") {
          Text(highlightedString: highlightedTitle,
               highlighted: { Text($0).foregroundColor(.blue) })
            .font(.system(.subheadline))
        } else {
          Text(product.object.name)
            .font(.system(.headline))
        }
        if !(product.object.brand ?? "").isEmpty {
          Text(product.object.brand!)
            .font(.system(.footnote))
            .foregroundColor(.gray)
        }
        if let priceString = product.object.price?.value {
          HStack(alignment: .bottom, spacing: 2) {
            Text(String(format: "%.2f€", priceString))
              .foregroundColor(.black)
              .font(.system(.caption))
          }
        }
      }
      .padding()
      .background(Color.white)
      .cornerRadius(12)
      .onAppear {
        productsHitsController.notifyAppearanceOfHit(atIndex: index)
      }
    }
    
  }
  
  class ViewController: UIHostingController<ContentView> {
    
    let controller: Controller
    
    init() {
      controller = .init()
      let contentView = ContentView(queryInputController: controller.queryInputController,
                                    suggestionsHitsController: controller.suggestionsHitsController,
                                    productsHitsController: controller.productsHitsController)
      super.init(rootView: contentView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
  }
  
  static let controller = Controller()
  static var previews: some View {
    _ = controller
    return NavigationView {
      ContentView(queryInputController: controller.queryInputController,
                  suggestionsHitsController: controller.suggestionsHitsController,
                  productsHitsController: controller.productsHitsController)
      .navigationBarTitle("Paging Multiple Index")
    }
  }
}
