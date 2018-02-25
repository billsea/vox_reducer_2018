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

  if (([[[UIDevice currentDevice] systemVersion]
           compare:@"8.0"
           options:NSNumericSearch] == NSOrderedAscending)) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message_title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];

    [alert dismissWithClickedButtonIndex:0 animated:TRUE];
    [alert show];
  } else {
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
}

@end
