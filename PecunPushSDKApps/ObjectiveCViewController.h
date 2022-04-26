//
//  ObjectiveCViewController.h
//  PecunPushSDKApps
//
//  Created by Carlos Arismendy on 25/4/22.
//

#import <UIKit/UIKit.h>
#import "PecunPushSDKApps-Swift.h"

@interface ObjectiveCViewController : UITableViewController


@property (weak, nonatomic) IBOutlet UITextField *mpTf;
@property (weak, nonatomic) IBOutlet UITextField *otpTf;
@property (weak, nonatomic) IBOutlet UITextField *nifTf;
@property (weak, nonatomic) IBOutlet UITextField *uuidTf;
@property (weak, nonatomic) IBOutlet UITextField *nifBiometricTf;

@end
