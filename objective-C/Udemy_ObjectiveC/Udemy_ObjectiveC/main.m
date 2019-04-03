//
//  main.m
//  Udemy_ObjectiveC
//
//  Created by Ari on 27/03/2019.
//  Copyright © 2019 ssungnni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        int i, triangularNumber;
        triangularNumber = 0; // 초기화
        
        for (0; i<10; i++) {
            NSLog(@"%i", i);
        }
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
