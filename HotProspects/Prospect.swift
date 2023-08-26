//
//  Prospect.swift
//  HotProspects
//
//  Created by Conner Glasgow on 9/16/22.
//

import Foundation


class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
}

@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
//    let savePathProspects = FileManager.documentsDirectory.appendingPathComponent("SavedProspects")
    let savePathProspects = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("SavedProspects")
        
    
    init() {
        do {
            let data = try Data(contentsOf: savePathProspects)
            people = try JSONDecoder().decode([Prospect].self, from: data)
        } catch {
            people = []
        }
    }
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(people)
            try data.write(to: savePathProspects, options: [.atomic, .completeFileProtection])
        } catch {
            print("Can't Save! ... \(error.localizedDescription)")
        }
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func toogle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
}
