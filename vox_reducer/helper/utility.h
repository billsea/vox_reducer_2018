//
//  utility.h
//  vrMobile
//
//  Created by Loud on 6/3/17.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface utility : NSObject
+ (void)showAlertWithTitle:(NSString *)message_title
                andMessage:(NSString *)message
                     andVC:(UIViewController *)vc;
@end
