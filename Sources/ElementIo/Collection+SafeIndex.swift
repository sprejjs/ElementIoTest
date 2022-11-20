//
//  File.swift
//  
//
//  Created by Allan Spreys on 20/11/2022.
//

import Foundation

extension Collection {
  /// Subscript function allowing accessing an element from a collection without throwing an outof bounds exception.
  /// Referefence: https://stackoverflow.com/a/30593673/1672972
  /// - Parameters:
  ///   - index: Index of the desired element
  /// - Returns: Element at required index or `nil` if element doesn't exist.
  subscript (safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
