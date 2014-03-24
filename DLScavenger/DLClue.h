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
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;

@end
