/// Copyright (c) 2023 Kodeco Inc.
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

@MainActor class ListViewModel: ObservableObject {
  // Properties
  @Published var state: State = .initial

  let localStore = LocalStore()
  let networkStore = NetworkStore()

  // Method called by the List View that handles the state
  func getEntries() async {
    do {
      let entries = try await getData()
      state = .success(data: entries)
    } catch {
      state = .failed(error: error)
      print(error.localizedDescription)
    }
  }

  // Helper method that calls the loading logic from network store and local store
  // Returns [Entry] if either succeeds.
  // Throws an error if both fail.
  private func getData() async throws -> [Entry] {
    if let data = try? await networkStore.fetchEntries() {
      print("Data loaded from network.")
      return data
    }
    if let data = try? localStore.loadFromDocuments(for: localStore.fileName) {
      print("Data loaded from documents.")
      return data
    }
    throw AppError.general
  }
}

// MARK: - State of the List View
extension ListViewModel {
  /// State of a network and local (load data from documents) calls.
  ///
  /// State is initialized with `.initial` state at the start and returns another state based on the logic.
  /// It can be `.success` or `.failure`
  enum State {
    /// Initial state
    case initial
    /// Network or local call succeeded and returns **data** as an array of `Employee`.
    /// The logic is handled for either or both.
    case success(data: [Entry])
    /// Network or local call failed and returns an **error** as `Error`.
    /// The logic is handled for either or both.
    case failed(error: Error)
  }
}

// MARK: - App Error

/// An error presented to the user with localized description.
enum AppError: LocalizedError {
  case general

  var errorDescription: String? {
    switch self {
      case .general:
        return "Uh-oh, something's gone wrong. Please check again later or file a support ticket."
    }
  }
}
