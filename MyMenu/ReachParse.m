//
//  ReachParse.m
//  MyMenu
//
//  Created by Massimo Moro on 24/02/15.
//  Copyright (c) 2015 MassimoMoro. All rights reserved.
//

#import "ReachParse.h"
#import "Reachability.h"

@implementation ReachParse

- (void)monitorReachability {
    Reachability *hostReach = [Reachability reachabilityWithHostname:@"api.parse.com"];
    
    hostReach.reachableBlock = ^(Reachability*reach) {
        _networkStatus = [reach currentReachabilityStatus];
        
        if ([self isParseReachable]) {// && self.homeViewController.objects.count == 0) {
            NSLog(@"Reachable!");
        }
    };
    
    hostReach.unreachableBlock = ^(Reachability*reach) {
        _networkStatus = [reach currentReachabilityStatus];
        NSLog(@"Not Reachable!");
    };
    
    [hostReach startNotifier];
}

- (BOOL)isParseReachable {
    return self.networkStatus != NotReachable;
}

@end
