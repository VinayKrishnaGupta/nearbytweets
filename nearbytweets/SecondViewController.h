//
//  SecondViewController.h
//  nearbytweets
//
//  Created by IAUGMENTOR on 14/01/17.
//  Copyright © 2017 Vinay Krishna Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController
- (IBAction)checkTweets:(UIButton *)sender;
@property(strong, nonatomic) NSString* hashtag;
@property(strong, nonatomic)NSString* Radius;
@property(strong, nonatomic)NSString* Latitudeselected;
@property(strong, nonatomic)NSString* Longitudeselected;
@property (strong, nonatomic) IBOutlet UITextField *hashtagtextfield;
@property (strong, nonatomic) IBOutlet UITextField *radiusTextfield;




@end
