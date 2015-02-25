//
//  ReachParse.h
//  MyMenu
//
//  Created by Massimo Moro on 24/02/15.
//  Copyright (c) 2015 MassimoMoro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReachParse : NSObject
@property (nonatomic, readonly) int networkStatus;
- (void)monitorReachability;
- (BOOL)isParseReachable;
@end
