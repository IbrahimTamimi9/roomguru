//
//  GroupedListViewModel.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 13/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol ExtendedIndexPathOperatable: IndexPathOperatable {
    func indexPathsForItems(items: [GroupItem]) -> [NSIndexPath]?
    func indexPathsForItemOfType(itemType: GroupItem.Type) -> [NSIndexPath]?
}

class GroupedListViewModel: ListViewModel<GroupItem> {
    
    init(items: [[GroupItem]]) {
        super.init(sections: items.map { Section($0) })
    }
}

extension GroupedListViewModel: ExtendedIndexPathOperatable {
    
    func indexPathsForItems(items: [GroupItem]) -> [NSIndexPath]? {
        var indexPaths: [NSIndexPath] = []

        itemize { (path, item) -> () in
            if items.contains(item) {
                indexPaths.append(NSIndexPath(forRow: path.row, inSection: path.section))
            }
        }
        
        return indexPaths.isEmpty ? nil : indexPaths
    }
    
    func indexPathsForItemOfType(itemType: GroupItem.Type) -> [NSIndexPath]? {
        var indexPaths: [NSIndexPath] = []
        
        itemize { path, item in
            indexPaths.append(NSIndexPath(forRow: path.row, inSection: path.section))
        }
        return indexPaths.isEmpty ? nil : indexPaths
    }
}
