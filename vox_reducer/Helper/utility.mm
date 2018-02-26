//
//  utility.m
//  vrMobile
//
//  Created by Loud on 6/3/17.
//
//

#import "utility.h"

@implementation utility

+ (void)showAlertWithTitle:(NSString *)message_title
                andMessage:(NSString *)message
                     andVC:(UIViewController *)vc {

    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:message_title
                         message:message
                  preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *defaultAction =
        [UIAlertAction actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action){
                               }];

    [alert addAction:defaultAction];
    [vc presentViewController:alert animated:YES completion:nil];
}

@end
