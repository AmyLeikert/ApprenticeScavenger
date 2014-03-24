//
//  DLClue.h
//  DLScavenger
//
//  Created by Tim Fether on 3/24/14.
//  Copyright (c) 2014 DetroitLabsUser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLClue : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *clueText;
@property (nonatomic) UIImage *clueImage;
@property (nonatomic) BOOL complete;

// TODO: include a property for the location, preferably a polygon of sorts, so that bigger locations can register as found from any spot within the polygon.

@end
