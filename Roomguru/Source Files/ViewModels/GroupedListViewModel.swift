//
//  GroupedListViewModel.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 13/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol ExtendedIndexPathOperatable: IndexPathOperatable {
    typealias T
    func indexPathsForItems(items: [GroupItem]) -> [NSIndexPath]?
    func indexPathsForItemOfType<T: GroupItem>(itemType: T.Type) -> [NSIndexPath]?
}

class GroupedListViewModel<T: GroupItem>: ListViewModel<T> {
    
    // NGRFixme: Use super.init(sections:)
    init(items: [[T]]) {
//        let sections = items.map { Section($0) }
        super.init()
    }
}

extension GroupedListViewModel: ExtendedIndexPathOperatable {
    typealias T = GroupItem
    
    func indexPathsForItems(items: [GroupItem]) -> [NSIndexPath]? {
        var indexPaths: [NSIndexPath] = []

        itemize { (path, item) -> () in
            if items.contains(item) {
                indexPaths.append(NSIndexPath(forRow: path.row, inSection: path.section))
            }
        }
        
        return indexPaths.isEmpty ? nil : indexPaths
    }
    
    func indexPathsForItemOfType<T: GroupItem>(itemType: T.Type) -> [NSIndexPath]? {
        var indexPaths: [NSIndexPath] = []
        
        itemize { path, item in
            if item is T {
                indexPaths.append(NSIndexPath(forRow: path.row, inSection: path.section))
            }
        }
        return indexPaths.isEmpty ? nil : indexPaths
    }
}
