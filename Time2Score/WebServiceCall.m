//
//  WebServiceCall.m
//  finder
//
//  Created by Joshua Balogun on 12/18/14.
//  Copyright (c) 2014 Etisalat. All rights reserved.
//

#import "WebServiceCall.h"
#import <Foundation/Foundation.h>

#define base_url @"http://192.231.249.98/superiorbet/public/api/auth/"
#define access_token @"33333"


@implementation WebServiceCall




- (NSDictionary *)status:(NSString *)phoneno
{
    
    NSMutableString *URLString = [[NSMutableString alloc] initWithString:base_url];
    
    [URLString appendString:@"status"];
    
    NSString *requestData = [NSString stringWithFormat:@"phone=%@",phoneno];
    //NSLog(@"body :: %@",requestData);
    
    
    id json = [self processRequestNResponse:URLString:requestData:@"POST"];
    
    NSDictionary *result = json;
    
    return result;
}


- (NSDictionary *)signup:(NSString *)fname :(NSString *)lname :(NSString *)phone :(NSString *)passowrd :(NSString *)email
{
    NSMutableString *URLString = [[NSMutableString alloc] initWithString:base_url];
    
    [URLString appendString:@"signup"];
    
    NSString *requestData = [NSString stringWithFormat:@"firstname=%@&lastname=%@&email=%@&phone=%@&password=%@",fname,lname,email,phone,passowrd];
    //NSLog(@"body :: %@",requestData);
    
    
    id json = [self processRequestNResponse:URLString:requestData:@"POST"];
    
    NSDictionary *result = json;
    
    return result;
}


- (NSDictionary *)login:(NSString *)phone :(NSString *)pass
{
    NSMutableString *URLString = [[NSMutableString alloc] initWithString:base_url];
    
    [URLString appendString:@"login"];
    
    NSString *requestData = [NSString stringWithFormat:@"phone=%@&password=%@",phone,pass];
    //NSLog(@"body :: %@",requestData);
    
    
    id json = [self processRequestNResponse:URLString:requestData:@"POST"];
    
    NSDictionary *result = json;
    
    return result;
}
    

- (NSDictionary *)recharge:(NSString *)token :(NSString *)voucher
{
    NSMutableString *URLString = [[NSMutableString alloc] initWithString:base_url];
    
    [URLString appendString:@"creditwallet"];
    
    NSString *requestData = [NSString stringWithFormat:@"token=%@&pin=%@",token,voucher];
    //NSLog(@"body :: %@",requestData);
    
    
    id json = [self processRequestNResponse:URLString:requestData:@"POST"];
    
    NSDictionary *result = json;
    
    return result;
}


- (NSDictionary *)balance:(NSString *)token
{
    NSMutableString *URLString = [[NSMutableString alloc] initWithString:base_url];
    
    [URLString appendString:@"walletBalance"];
    
    NSString *requestData = [NSString stringWithFormat:@"token=%@",token];
    //NSLog(@"body :: %@",requestData);
    
    
    id json = [self processRequestNResponse:URLString:requestData:@"POST"];
    
    NSDictionary *result = json;
    
    return result;
}


- (NSDictionary *)cashout:(NSString *)token :(NSString *)channel :(NSString *)amount
{
    NSMutableString *URLString = [[NSMutableString alloc] initWithString:base_url];
    
    [URLString appendString:@"cashout"];
    
    NSString *requestData = [NSString stringWithFormat:@"token=%@&channel=%@&amount=%@",token,channel,amount];
    //NSLog(@"body :: %@",requestData);
    
    
    id json = [self processRequestNResponse:URLString:requestData:@"POST"];
    
    NSDictionary *result = json;
    
    return result;
}


- (NSDictionary *)transfer:(NSString *)token :(NSString *)destination :(NSString *)amount
{
    NSMutableString *URLString = [[NSMutableString alloc] initWithString:base_url];
    
    [URLString appendString:@"transfer"];
    
    NSString *requestData = [NSString stringWithFormat:@"token=%@&destination=%@&amount=%@",token,destination,amount];
    //NSLog(@"body :: %@",requestData);
    
    
    id json = [self processRequestNResponse:URLString:requestData:@"POST"];
    
    NSDictionary *result = json;
    
    return result;
}


- (NSDictionary *)passwordreset:(NSString *)phone
{
    NSMutableString *URLString = [[NSMutableString alloc] initWithString:base_url];
    
    [URLString appendString:@"passwordReset"];
    
    NSString *requestData = [NSString stringWithFormat:@"phone=%@",phone];
    //NSLog(@"body :: %@",requestData);
    
    
    id json = [self processRequestNResponse:URLString:requestData:@"POST"];
    
    NSDictionary *result = json;
    
    return result;
}


- (NSDictionary *)profile:(NSString *)token :(NSString *)firstname :(NSString *)lastname :(NSString *)email
{
    NSMutableString *URLString = [[NSMutableString alloc] initWithString:base_url];
    
    [URLString appendString:@"updateProfile"];
    
    NSString *requestData = [NSString stringWithFormat:@"token=%@&firstname=%@&lastname=%@&email=%@",token,firstname,lastname,email];
    //NSLog(@"body :: %@",requestData);
    
    
    id json = [self processRequestNResponse:URLString:requestData:@"POST"];
    
    NSDictionary *result = json;
    
    return result;
}


- (NSDictionary *)password:(NSString *)token :(NSString *)currentpassword :(NSString *)newpassword
{
    NSMutableString *URLString = [[NSMutableString alloc] initWithString:base_url];
    
    [URLString appendString:@"changePassword"];
    
    NSString *requestData = [NSString stringWithFormat:@"token=%@&current=%@&new=%@",token,currentpassword,newpassword];
    //NSLog(@"body :: %@",requestData);
    
    
    id json = [self processRequestNResponse:URLString:requestData:@"POST"];
    
    NSDictionary *result = json;
    
    return result;
}


- (NSDictionary *)history:(NSString *)token
{
    NSMutableString *URLString = [[NSMutableString alloc] initWithString:base_url];
    
    [URLString appendString:@"history"];
    
    NSString *requestData = [NSString stringWithFormat:@"token=%@",token];
    //NSLog(@"body :: %@",requestData);
    
    
    id json = [self processRequestNResponse:URLString:requestData:@"POST"];
    
    NSDictionary *result = json;
    
    return result;
}


- (NSDictionary *)matches
{
    NSMutableString *URLString = [[NSMutableString alloc] initWithString:base_url];
    
    [URLString appendString:@"fixtures"];
    
    NSString *requestData = @"";
    //NSLog(@"body :: %@",requestData);
    
    
    id json = [self processRequestNResponse:URLString:requestData:@"GET"];
    
    NSDictionary *result = json;
    
    return result;
}


- (NSDictionary *)play:(NSString *)token :(NSString *)matchcode :(NSString *)slots
{
    NSMutableString *URLString = [[NSMutableString alloc] initWithString:base_url];
    
    [URLString appendString:@"predictGoaltime"];
    
    NSString *requestData = [NSString stringWithFormat:@"token=%@&matchcode=%@&slots=%@",token,matchcode,slots];
    //NSLog(@"body :: %@",requestData);
    
    
    id json = [self processRequestNResponse:URLString:requestData:@"POST"];
    
    NSDictionary *result = json;
    
    return result;
}


- (NSDictionary *)statistics:(NSString *)matchcode
{
    NSMutableString *URLString = [[NSMutableString alloc] initWithString:base_url];
    
    [URLString appendString:@"statistics"];
    
    NSString *requestData = [NSString stringWithFormat:@"matchcode=%@",matchcode];
    //NSLog(@"body :: %@",requestData);
    
    
    id json = [self processRequestNResponse:URLString:requestData:@"POST"];
    
    NSDictionary *result = json;
    
    return result;
}


- (NSDictionary *)currentslot:(NSString *)matchcode
{
    NSMutableString *URLString = [[NSMutableString alloc] initWithString:base_url];
    
    [URLString appendString:@"currentSlot"];
    
    NSString *requestData = [NSString stringWithFormat:@"matchcode=%@",matchcode];
    //NSLog(@"body :: %@",requestData);
    
    
    id json = [self processRequestNResponse:URLString:requestData:@"POST"];
    
    NSDictionary *result = json;
    
    return result;
}


- (NSDictionary *)leaguetable:(NSString *)country
{
    NSMutableString *URLString = [[NSMutableString alloc] initWithString:base_url];
    
    [URLString appendString:@"leagueTable"];
    
    NSString *requestData = [NSString stringWithFormat:@"country=%@",country];
    //NSLog(@"body :: %@",requestData);
    
    
    id json = [self processRequestNResponse:URLString:requestData:@"POST"];
    
    NSDictionary *result = json;
    
    return result;
}


- (id)processRequestNResponse:(NSMutableString *)URLString :(NSString *)requestData :(NSString *)method
{
    
    NSURL *URL = [NSURL URLWithString:URLString];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    
    //Request
    [request setHTTPMethod:method];

    if ([method isEqualToString:@"POST"])
    {
        NSString *myString = [NSString stringWithFormat:@"%@",requestData];
        [request setHTTPBody:[myString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //Response
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (data == nil)
    {
        NSDictionary *errorData = @{ @"success":@"9", @"message":[error localizedDescription] };
        data = [NSJSONSerialization dataWithJSONObject:errorData options:NSJSONWritingPrettyPrinted error:&error];
    }
    
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (json == nil)
    {
        NSDictionary *errorData = @{ @"success":@"10", @"message":@"sorry operation failed, please try again later." };
        data = [NSJSONSerialization dataWithJSONObject:errorData options:NSJSONWritingPrettyPrinted error:&error];
        json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    }
    
    return json;
    
}


@end
