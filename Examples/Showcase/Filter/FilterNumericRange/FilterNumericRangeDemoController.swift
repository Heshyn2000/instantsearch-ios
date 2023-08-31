//
//  FilterNumericRangeDemoController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 30/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore

class FilterNumericRangeDemoController {
  let searcher: HitsSearcher
  let filterState: FilterState
  let filterClearConnector: FilterClearConnector

  let searchBoxConnector: SearchBoxConnector
  let rangeConnector: NumberRangeConnector<Double>
  let statsConnector: StatsConnector

  init() {
    searcher = HitsSearcher(appID: "0ZV04HYYVJ",
                            apiKey: "f220c49aa52fca828fe5265965a0cab3",
                            indexName: "r-development-US__products___price-low-to-high")
    filterState = .init()
    filterClearConnector = .init(filterState: filterState)
    rangeConnector = .init(searcher: searcher,
                           filterState: filterState,
                           attribute: "price.number")
    statsConnector = .init(searcher: searcher)
    searchBoxConnector = .init(searcher: searcher)
    searcher.connectFilterState(filterState)
    searcher.search()
  }
}
