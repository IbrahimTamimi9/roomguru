//
//  ListViewModel.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 18/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

typealias Path = (section: Int, row: Int)

protocol Itemizable {
    typealias T
    func itemize(closure: (path: Path, item: T) -> ())
}

protocol IndexPathOperatable {
    typealias T
    func addItem(item: T, atIndexPath indexPath: NSIndexPath)
    func removeAtIndexPath(indexPath: NSIndexPath)
    func removeItemsAtIndexPaths(indexPaths: [NSIndexPath])
}

class ListViewModel<T: Equatable> {
    
    typealias Table = List<Section<T>>
    
    var sections: Table = Table([Section<T>([])])
    
    required init(_ items: [T]) {
        sections = Table([Section<T>(items)])
    }
    
    required init<U: Equatable>(_ items: [T], readValue: T -> U) {
        sections = sectionsFromItems(items, byReadingValue: readValue) ?? Table([Section<T>(items)])
    }
    
    required init(sections: [Section<T>]) {
        self.sections = Table(sections)
    }
    
    subscript(index: Int) -> List<T> {
        return sections[index]
    }
    
    subscript(index: Int) -> T? {
        return sections[0][index]
    }
        
    func sectionsCount() -> Int {
        return sections.count
    }
}

// MARK: Itemizable

extension ListViewModel: Itemizable {
    
    func itemize(closure: (path: Path, item: T) -> ()) {
        sections.itemize { section, item in
            item.itemize { closure(path: (section, $0), item: $1) }
        }
    }
}

// MARK: IndexPathOperatable

extension ListViewModel: IndexPathOperatable {
    
    func getItemAtIndexPath(indexPath: NSIndexPath) -> T {
        return sections[indexPath.section][indexPath.row];
    }
    
    func addItem(item: T, atIndexPath indexPath: NSIndexPath) {
        sections[indexPath.section].add(item, atIndex: indexPath.row)
    }
    
    func removeAtIndexPath(indexPath: NSIndexPath) {
        sections[indexPath.section].remove(indexPath.row)
    }
    
    func removeItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
        for indexPath in indexPaths {
            removeAtIndexPath(indexPath)
        }
    }
}

// MARK: Private

private extension ListViewModel {
    
    func sectionsFromItems<U: Equatable>(items: [T], byReadingValue readValue: T -> U) -> Table? {
        
        let values = items.map { readValue($0) }
        
        let sections: [Section<T>] = values.uniques.map { item in
            
            let section = Section(items.filter { item == readValue($0) } )
            
            if let item = item as? StringConvertible {
                section.title = item.string()
            }
            return section
        }
        
        return Table(sections)
    }
}

extension Array where Element: Equatable {
    
    var uniques: [Element] {
        var uniques = [Element]()
        for element in self {
            if !uniques.contains(element) {
                uniques.append(element)
            }
        }
        return uniques
    }
}
