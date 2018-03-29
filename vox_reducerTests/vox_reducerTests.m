//
//  vox_reducerTests.m
//  vox_reducerTests
//
//  Created by Loud on 3/29/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TargetViewController.h"

@interface vox_reducerTests : XCTestCase
@property (nonatomic) TargetViewController *vcToTest;
@end



@implementation vox_reducerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
	
	_vcToTest = [[TargetViewController alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {

}


@end
