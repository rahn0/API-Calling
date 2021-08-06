//
//  ContentView.swift
//  API Calling
//
//  Created by Ryan Ahn on 7/29/21.
//

// API Calling for elements of the periodic table

import SwiftUI
struct ContentView: View {
    @State private var elements = [Element]()
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            List(elements) { element in
                NavigationLink(
                    destination: VStack {
                        Text(element.name)
                            .padding()
                        Text(element.symbol)
                            .padding()
                        Text(element.atomicNumber)
                            .padding()
                        Text(element.groupBlock)
                            .padding()
                        Text(element.history)
                            .padding()
                        Text(element.facts)
                            .padding()
                    },
                    label: {
                        HStack {
                            Text(element.symbol)
                            Text(element.name)
                        }
                    })
            }
            .navigationTitle("Elements of the Periodic Table")
        }
        .onAppear(perform: {
            queryAPI()
        })
        // Set up alert
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("Loading Error"),
                  message: Text("There was a problem loading the data"),
                  dismissButton: .default(Text("OK")))
        })
    }
    
    func queryAPI() {
        let apiKey = "?rapidapi-key=18ce8db0b9mshb5728dc31db90cbp133252jsn437bdccbd78f"
        let query = "https://periodictable.p.rapidapi.com/\(apiKey)"
        if let url = URL(string: query) {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                let contents = json.arrayValue
                for item in contents {
                    let name = item["name"].stringValue
                    let symbol = item["symbol"].stringValue
                    let atomicNumber = item["atomicNumber"].stringValue
                    let groupBlock = item["groupBlock"].stringValue
                    let facts = item["facts"].stringValue
                    let history = item["history"].stringValue
                    let element = Element(symbol: symbol, atomicNumber: atomicNumber, groupBlock: groupBlock, name: name, history: history, facts: facts)
                    elements.append(element)
                }
                return
            }
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Element: Identifiable {
    let id = UUID()
    let symbol: String
    let atomicNumber: String
    let groupBlock: String
    let name: String
    let history: String
    let facts: String
}
