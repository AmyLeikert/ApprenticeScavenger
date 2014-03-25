//
//  DLHunt.h
//  DLScavenger
//
//  Created by DetroitLabsUser on 3/25/14.
//  Copyright (c) 2014 DetroitLabsUser. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DLHuntStyle) {
    DLHuntStyleOrdered,                  // Displays clues in specific order
    DLHuntStyleUnordered                 // no set order to which clues may be viewed & solved
};

@interface DLHunt : NSObject

@property (nonatomic,strong) NSArray *clueArray;
@property (nonatomic) DLHuntStyle *huntStyle;

@end
