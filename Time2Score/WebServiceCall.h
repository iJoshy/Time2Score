//
//  WebServiceCall.h
//  TrustFund
//
//  Created by Joshua Balogun on 12/18/14.
//  Copyright (c) 2014 TrustFund. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebServiceCall : UIViewController

- (NSDictionary *)status:(NSString *)phone;
- (NSDictionary *)balance:(NSString *)token;
- (NSDictionary *)passwordreset:(NSString *)phone;
- (NSDictionary *)signup:(NSString *)fname :(NSString *)lname :(NSString *)phone :(NSString *)passowrd :(NSString *)email;
- (NSDictionary *)login:(NSString *)phone :(NSString *)pass;
- (NSDictionary *)recharge:(NSString *)token :(NSString *)voucher;
- (NSDictionary *)cashout:(NSString *)token :(NSString *)channel :(NSString *)amount;
- (NSDictionary *)transfer:(NSString *)token :(NSString *)destination :(NSString *)amount;
- (NSDictionary *)profile:(NSString *)token :(NSString *)firstname :(NSString *)lastname :(NSString *)email;
- (NSDictionary *)password:(NSString *)token :(NSString *)currentpassword :(NSString *)newpassword;
- (NSDictionary *)history:(NSString *)token;
- (NSDictionary *)matches;
- (NSDictionary *)play:(NSString *)token :(NSString *)matchcode :(NSString *)slots;
- (NSDictionary *)statistics:(NSString *)matchcode;
- (NSDictionary *)currentslot:(NSString *)matchcode;
- (NSDictionary *)leaguetable:(NSString *)country;

@end
