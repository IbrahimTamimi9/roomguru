//
//  EventsListViewModel.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 29/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class EventsListViewModel<T: CalendarEntry>: ListViewModel<CalendarEntry> {
    
    private var selectedFreeEventPaths: [NSIndexPath] = []
    
    required init(_ items: [T]) {
        super.init(items)
    }
    
    func eventAtIndex(indexPath: NSIndexPath) -> Event? {
        return self[indexPath.row]?.event
    }
    
    func indexOfItemWithDate(date: NSDate) -> Path? {
        
        var pathToReturn: Path?
        
        itemize { (path: Path, item: CalendarEntry) in
            if true {
                pathToReturn = path
            }
        }
        return pathToReturn
    }
    
    func selectOrDeselectFreeEventAtIndexPath(indexPath: NSIndexPath) {
        
        if containsIndexPath(indexPath) {
            selectedFreeEventPaths = selectedFreeEventPaths.filter { $0 != indexPath }
        } else {
            selectedFreeEventPaths.append(indexPath)
        }
    }
    
    func isFreeEventSelectedAtIndex(indexPath: NSIndexPath) -> (selected: Bool, lastUserSelection: Bool) {
        let lastUserSelection = selectedFreeEventPaths.last == indexPath
        return (selected: containsIndexPath(indexPath), lastUserSelection: lastUserSelection)
    }
    
    func indexPathsToReload() -> [NSIndexPath] {
        return selectedFreeEventPaths
    }
    
    func isSelectableIndex(indexPath: NSIndexPath) -> Bool {
        
        // when not free event, allow to select
        if !(eventAtIndex(indexPath) is FreeEvent) {
            return true
        }
        
        // when empty allow to select
        if selectedFreeEventPaths.isEmpty {
            return true
        }
        
        let beforeFreeEvent = isFreeEventBeforeIndexSelected(indexPath)
        let afterFreeEvent = isFreeEventAfterIndexSelected(indexPath)
        
        // when both, means event is in the middle, do not allow
        if beforeFreeEvent && afterFreeEvent {
            return false
        // when one of two, means event is boundary event
        } else if beforeFreeEvent || afterFreeEvent {
            return true
        // when contains, means one event left and exactly this one has been selected
        } else {
            return containsIndexPath(indexPath)
        }
    }
    
    func selectedTimeRangeToBook() -> TimeRange? {
        
        var selectedFreeEvents: [Event] = []
        
        itemize { (path: Path, item: CalendarEntry) in
            let indexPath = NSIndexPath(forRow: path.row, inSection: path.section)
            if let _ = self.selectedFreeEventPaths.indexOf(indexPath) {
                selectedFreeEvents.append(item.event)
            }
        }
        
        if selectedFreeEvents.isEmpty {
            return nil
        }
        
        let sortedFreeEvents = selectedFreeEvents.sort { $0 == $1 }
        return TimeRange(min: sortedFreeEvents.first!.start, max: sortedFreeEvents.last!.end)
    }
    
    func containsIndexPath(indexPath: NSIndexPath) -> Bool {
        return selectedFreeEventPaths.indexOf(indexPath) != nil
    }
}

private extension EventsListViewModel {
    
    func isFreeEventAfterIndexSelected(indexPath: NSIndexPath) -> Bool {
        if (indexPath.row == self[0].count - 1) {
            return false
        }
        if let _ = self[indexPath.row + 1]?.event as? FreeEvent {
            let path = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
            return containsIndexPath(path)
        }
        return false
    }
    
    func isFreeEventBeforeIndexSelected(indexPath: NSIndexPath) -> Bool {
        if (indexPath.row == 0) {
            return false
        }
        if let _ = self[indexPath.row - 1]?.event as? FreeEvent {
            let path = NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)
            return containsIndexPath(path)
        }
        return false
    }
}
