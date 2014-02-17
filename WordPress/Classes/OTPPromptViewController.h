//
//  OTPPromptViewController.h
//  WordPress
//
//  Created by Jorge Bernal on 11/02/14.
//  Copyright (c) 2014 WordPress. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OTPPromptViewControllerDelegate;

@interface OTPPromptViewController : UIViewController
@property (nonatomic, weak) id<OTPPromptViewControllerDelegate> delegate;

/**
 Stops any activity indicator and resets the view controller to asking for a code again
 */
- (void)resetAuthenticationState;
@end

@protocol OTPPromptViewControllerDelegate <NSObject>

- (void)promptDidCancel:(OTPPromptViewController *)prompt;
- (void)prompt:(OTPPromptViewController *)prompt didEnterPassword:(NSString *)oneTimePassword;

@end
