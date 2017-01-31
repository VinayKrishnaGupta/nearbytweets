//
//  SecondViewController.m
//  nearbytweets
//
//  Created by IAUGMENTOR on 14/01/17.
//  Copyright © 2017 Vinay Krishna Gupta. All rights reserved.
//

#import "SecondViewController.h"
#import "AFNetworking.h"
@import GooglePlacePicker;

@interface SecondViewController ()
// Add a pair of UILabels in Interface Builder, and connect the outlets to these variables.
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property(readonly, nonatomic) CLLocationCoordinate2D selectedcorinate;
@end

@implementation SecondViewController {
    GMSPlacePicker *_placePicker;
}


// Add a UIButton in Interface Builder, and connect the action to this function.
- (IBAction)pickPlace:(UIButton *)sender {
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(28.451276, 77.073268);
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(center.latitude + 0.001,
                                                                  center.longitude + 0.001);
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(center.latitude - 0.001,
                                                                  center.longitude - 0.001);
    GMSCoordinateBounds *viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
                                                                         coordinate:southWest];
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
    _placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    
    [_placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        if (place != nil) {
            self.nameLabel.text = place.name;
            self.addressLabel.text = [[place.formattedAddress
                                       componentsSeparatedByString:@", "] componentsJoinedByString:@"\n"];
            _Latitudeselected = [NSString stringWithFormat:@"%f",place.coordinate.latitude];
            _Longitudeselected = [NSString stringWithFormat:@"%f",place.coordinate.longitude];
            _selectedcorinate = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude);
          //  NSLog(@"Selected coordinate is %@",_selectedcorinate.latitude);
            
            
        } else {
            self.nameLabel.text = @"No place selected";
            self.addressLabel.text = @"";
        }
    }];
}
- (IBAction)checkTweets:(UIButton *)sender {
    _hashtag = _hashtagtextfield.text ;
    _Radius = _radiusTextfield.text;
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
  //  CLLocation *Selected = [[CLLocation alloc] initWithLatitude:_Latitudeselected longitude:_Longitudeselected];
    NSString *Locationselectedtobesent = [NSString stringWithFormat:@"%f,,%f,,%@km",_selectedcorinate.latitude,_selectedcorinate.longitude, _Radius];
      NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:_hashtag,@"q",Locationselectedtobesent,@"geocode", nil];
    
     NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/search/tweets.json?q=%@&geocode=%@",_hashtag,[NSString stringWithFormat:@"%f,%f, %@km",_selectedcorinate.latitude,_selectedcorinate.longitude, _Radius]] parameters:nil error:nil];
    
    
    
    
    //   [req setValue:@"cY5cc2hZcFLc3US9DpG3q3Tfp" forHTTPHeaderField:@"Key"];
    //  [req setValue:@"""" forHTTPHeaderField:@"Client"];
    [req setValue:@"OAuth oauth_consumer_key=\"qSbd1V3QSRmjjMrJGtpUZF70N\",oauth_token=\"163221330-t41FYvp6DxTtDUt1wSRmW9uvtmKVBdzkKgZgHCTf\",oauth_signature_method=\"HMAC-SHA1\",oauth_timestamp=\"1484393702\",oauth_nonce=\"7Tqgh6xZJ8M\",oauth_version=\"1.0\",oauth_signature=\"oATborQut18Q828iPT4%2FxhpjhjQ%3D\"" forHTTPHeaderField:@"Authorization"];
    
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Reply JSON for detail: %@", responseObject);
            NSString *count = [responseObject valueForKeyPath:@"search_metadata.count"];
            
            NSLog(@"Count is %@",count);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Total Tweets in selected location" message:[NSString stringWithFormat:@"%@",count] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil ];
            [alert show];
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
            }
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            
            
            
        }
    }] resume];

}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

@end
