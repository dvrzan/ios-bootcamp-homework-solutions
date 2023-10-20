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

class APIFileStore: ObservableObject {
  @Published var entries: [Entry] = []
  @Published var errorMessage: String?

  var documentDirectory: URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  }

  init() {
    loadModel(from: "apilist")
  }

  func loadModel(from fileName: String) {
    if !loadFromBundle(for: fileName) && !loadFromDocuments(for: fileName) {
      errorMessage = "Oops, something went wrong! Please try again."
    }
  }

  func loadFromBundle(for fileName: String) -> Bool {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
      print(DataError.invalidURL(fileName))
      return false
    }

    guard let data = try? Data(contentsOf: url) else {
      print(DataError.invalidData(fileName))
      return false
    }
    // Save to documents directory
    save(data: data, for: fileName)

    let decoder = JSONDecoder()
    guard let decodedData = try? decoder.decode(APIModel.self, from: data) else {
      print(DataError.decodeFailure)
      return false
    }
    entries = decodedData.entries
    print("Data loaded from app bundle!")
    return true
  }

  // MARK: Load from documents directory
  func loadFromDocuments(for fileName: String) -> Bool {
    let fileUrl = documentDirectory.appendingPathComponent("\(fileName).json")

    guard let data = try? Data(contentsOf: fileUrl) else {
      print(DataError.invalidData(fileName))
      return false
    }

    let decoder = JSONDecoder()
    guard let decodedData = try? decoder.decode(APIModel.self, from: data) else {
      print(DataError.decodeFailure)
      return false
    }
    entries = decodedData.entries
    print("Data loaded from documents!")
    return true
  }

  // MARK: Save data to documents directory
  func save(data: Data, for fileName: String) {
    let fileUrl = documentDirectory.appendingPathComponent("\(fileName).json")

    guard (try? data.write(to: fileUrl)) != nil else {
      print(DataError.saveFailure(fileUrl.path))
      return
    }
  }
}
