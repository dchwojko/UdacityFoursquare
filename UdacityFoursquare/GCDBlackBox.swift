//
//  GCDBlackBox.swift
//  UdacityFoursquare
//
//  Created by DONALD CHWOJKO on 10/18/17.
//  Copyright © 2017 DONALD CHWOJKO. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: @escaping () -> Void) {
    let queue = DispatchQueue(label: "myQueue")
    queue.async {
        DispatchQueue.main.async {
            updates()
        }
    }
}

