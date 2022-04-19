//
//  ContentView.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/04/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

struct ContentView: View {
  
  @ObservedObject var queryInputController: QueryInputObservableController
  @ObservedObject var hitsController: HitsObservableController<StockItem>
  @ObservedObject var statsController: StatsTextObservableController
  @ObservedObject var facetListController: FacetListObservableController

  @State private var isEditing = false
  @State private var isPresentingFacets = false
  
  var body: some View {
    VStack(spacing: 7) {
      SearchBar(text: $queryInputController.query,
                isEditing: $isEditing,
                onSubmit: queryInputController.submit)
      Text(statsController.stats)
        .fontWeight(.medium)
      HitsList(hitsController) { (hit, _) in
        VStack(alignment: .leading, spacing: 10) {
          Text(hit?.name ?? "")
            .padding(.all, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
          Divider()
        }
      } noResults: {
        Text("No Results")
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .padding()
    .navigationBarTitle("Algolia & SwiftUI")
    .navigationBarItems(trailing: facetsButton())
    .sheet(isPresented: $isPresentingFacets, content: facets)
  }
  
  @ViewBuilder
  private func facets() -> some View {
    NavigationView {
      ScrollView {
        FacetList(facetListController) { facet, isSelected in
          VStack {
            FacetRow(facet: facet, isSelected: isSelected)
              .padding()
            Divider()
          }
        } noResults: {
          Text("No facet found")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }
      .navigationBarTitle("Brand")
    }
  }
  
  private func facetsButton() -> some View {
    Button(action: {
      isPresentingFacets.toggle()
    },
    label: {
      Image(systemName: "line.horizontal.3.decrease.circle")
        .font(.title)
    })
  }
  
}
