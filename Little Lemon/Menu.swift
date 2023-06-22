//
//  Menu.swift
//  Little Lemon
//
//  Created by Christian Pedersen on 20/06/2023.
//

import SwiftUI

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var searchText = ""
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Little Lemon").font(.title).foregroundColor(Color("Secondary"))
                        Text("Chicago").font(.headline)
                        Text("The Litle Lemon app enables you to quickly and easily order from our wide range of authentic mediterranean cuisine.")
                    }
                    Image("HeroBanner").resizable().aspectRatio(contentMode: .fill).frame(width: 100, height: 100).cornerRadius(5)
                }
                
                TextField("Search menu", text: $searchText)
                    .padding()
                    .background(.white)
                    .foregroundColor(.gray)
                    .cornerRadius(5)
            }.padding().background(Color("Primary")).foregroundColor(.white)
            
            FetchedObjects(
                predicate: buildPredicate(),
                sortDescriptors: buildSortDescriptors()
            ) { (dishes: [Dish]) in
                List {
                    ForEach(dishes, id: \.id) { dish in
                        HStack {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(dish.title!).font(.headline)
                                Text(dish.details!)
                                Text("$" + dish.price!).font(.headline)
                            }
                            
                            Spacer()
                            
                            AsyncImage(url: URL(string: dish.image!)) { image in
                                image.resizable().cornerRadius(5)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100)
                        }.padding(.vertical)
                    }
                }
                .listStyle(.plain)
            }
        }
        .onAppear(perform: getMenuData)
    }
    
    func getMenuData() {
        PersistenceController.shared.clear()
        
        let source = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        let url = URL(string: source)!
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                let result = try? decoder.decode(MenuList.self, from: data)
                
                if let menu = result?.menu {
                    for item in menu {
                        let dish = Dish(context: viewContext)
                        dish.title = item.title
                        dish.details = item.description
                        dish.image = item.image
                        dish.price = item.price
                    }
                }
                
                try? viewContext.save()
            }
        }
        
        task.resume()
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [
            NSSortDescriptor(
                key: "title",
                ascending: true,
                selector: #selector(NSString.localizedStandardCompare(_:))
            )
        ]
    }
    
    func buildPredicate() -> NSPredicate {
        if searchText.isEmpty {
            return NSPredicate(value: true)
        }
        
        return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
