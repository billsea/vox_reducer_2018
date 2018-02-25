//
//  InfoViewController.h
//  vrMobile
//
//  Created by bill on 9/5/11.
//  Copyright 2011 _Loudsoftware_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController
@property(nonatomic, retain) NSString *SenderName;
@property(nonatomic, retain) IBOutlet UILabel *titleLabel;
@property(nonatomic, retain) IBOutlet UITextView *infoText;
@end
