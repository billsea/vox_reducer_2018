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
	
	self.vcToTest = [[TargetViewController alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSenderName {
	NSString* name = @"testName";
	self.vcToTest.senderName = name;
	NSString* retName = self.vcToTest.senderName;
	
	//Just to confirm unit test is working properly
	NSString* expectedName = @"testNameWrong";

	//The XCTAssertEqualObjects function is part of the XCTest framework. The XCTest framework provides many other methods to make assertions about application state, such as variable equality or boolean expression results
	XCTAssertEqualObjects(expectedName, retName, @"strings did not match");
}

//Performance test - time it take to complete call
- (void)testPerformanceSender {
	[self measureBlock:^{
		self.vcToTest.senderName;
	}];
}


@end
