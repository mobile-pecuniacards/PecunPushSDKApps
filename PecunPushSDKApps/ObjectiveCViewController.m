//
//  ObjectiveCViewController.m
//  PecunPushSDKApps
//
//  Created by Carlos Arismendy on 25/4/22.
//

#import <Foundation/Foundation.h>
#import "PecunPushSDKApps-Swift.h"
#import "ObjectiveCViewController.h"

@import Foundation;
@import UserNotifications;
@import PecunPushSDK;
@import FirebaseMessaging;


@interface ObjectiveCViewController () <UNUserNotificationCenterDelegate, PSD2CallerDelegate, PendingPurchaseDelegate, LinkBiometricDelegate>

@property (nonatomic) NotificationReference *referenceToken;
@end

@implementation ObjectiveCViewController

- (void)viewDidLoad {
   [super viewDidLoad];
      // Do any additional setup after loading the view.
   self.referenceToken = [[NotificationReference alloc]initWithMessaging:[FIRMessaging messaging]];
   PecunAppearence.buttonColor = UIColor.redColor;
   self.mpTf.text = @"A0323JY";
}

-(IBAction)openViewAction:(id)sender
{
   if (self.nifTf.text == nil || self.nifTf.text.length == 0  ) {
      [self alert:@"Introduzca NIF" msg:@"Pending Purchase"];
      return;
   }
   PendingPurchaseViewController* viewController = [PecunPush openPendingPurchaseWithDelegate: self identityDocument:self.nifTf.text otpCode:@""];
   [self.navigationController presentViewController:viewController animated:false completion:nil];
}

-(IBAction)validateOperation:(id)sender
{
   if (self.uuidTf.text == nil || self.uuidTf.text.length == 0  ) {
      [self alert:@"Introduzca UUID" msg:@"Validate Operation"];
      return;
   }
   ValidateSCAViewController *viewController = [PecunPush openValidateSCAOperationWithUuid:self.uuidTf.text delegate:self];
   [self.navigationController presentViewController:viewController animated:false completion:nil];
}

-(IBAction)linkBiometricAction:(id)sender
{
   if (self.nifBiometricTf.text == nil || self.nifBiometricTf.text.length == 0  ) {
      [self alert:@"Introduzca NIF" msg:@"Link Biometric"];
      return;
   }
   LinkBiometricViewController *viewController = [PecunPush openLinkBiometricWithDelegate:self userIdentity:self.nifBiometricTf.text];
   [self.navigationController presentViewController:viewController animated:false completion:nil];
}


- (void)resendCall {

}

- (void)PendingPurchaseFinishKo {

}

- (void)PendingPurchaseFinishOk {

}

- (void) alert:(NSString*) title msg:(NSString*) message {
   UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
   UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         //button click event
   }];
   [alert addAction:ok];
   [self.navigationController presentViewController:alert animated:false completion:nil];
}

- (void)linkBiometricFinishKo {

}

- (void)linkBiometricFinishOk {

}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {

}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {

}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {

}

- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
   return CGSizeMake(0, 0);
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {

}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {

}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {

}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {

}

- (void)setNeedsFocusUpdate {

}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
   return true;
}

- (void)updateFocusIfNeeded {

}

@end
