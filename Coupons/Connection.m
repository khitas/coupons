//
//  Connection.m
//  Coupons
//
//  Created by Kwstas Xytas on 27/7/12.
//
//

#import "Connection.h"
#import "AppDelegate.h"
#import "SBJson/SBJson.h"
#import "clsSettings.h"

@implementation Connection


-(NSDictionary *) login:(NSString *)userName andPassWord:(NSString *)passWord
{
    NSHTTPURLResponse   *response;
    NSData *responseData;
    
    NSMutableURLRequest *request;
    NSData *requestData;
    
    NSError *error;
    
    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://coupons.teiath.gr/users/login"]
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:60];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    requestData = [[NSString stringWithFormat:@"{\"User\": {\"username\":\"%@\", \"password\": \"%@\"}}", userName, passWord]  dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    
    NSLog(@"Request:\n%@", [[NSString alloc] initWithFormat:@"%@", request]);
    NSLog(@"RequestData:\n%@", [[NSString alloc] initWithData:requestData  encoding: NSUTF8StringEncoding]);
    NSLog(@"RequestHeaders: \n%@\n", [request allHTTPHeaderFields]);
    
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"Respose:\n%@", [[NSString alloc] initWithData:responseData  encoding: NSUTF8StringEncoding]);
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];

    if (error)
        return [parser objectWithString:[[NSString alloc] initWithFormat:@"{\"status_code\":\"%d\",\"message\":\"%@\"}", [error code], [error localizedDescription] ]error:nil];
    else
        return [parser objectWithString:[[NSString alloc] initWithData:responseData encoding: NSUTF8StringEncoding] error:nil];
}


-(NSDictionary *) autoLogin
{
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if (([[[myAppDelegate Settings] userName] isEqualToString:@""]) ||([[[myAppDelegate Settings] passWord] isEqualToString:@""]))
    {
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSLog(@"{\"status_code\":\"%d\",\"message\":\"%@\"}", 100, @"Η αυτόματη επανασύνδεση με τα στοιχεία πρόσβασης που έχετε καταχωρήσει παρουσιάζει σφάλμα.");
        
        return [parser objectWithString:[[NSString alloc] initWithFormat:@"{\"status_code\":\"%d\",\"message\":\"%@\"}", 100, @"Η αυτόματη επανασύνδεση με τα στοιχεία πρόσβασης που έχετε καταχωρήσει παρουσιάζει σφάλμα." ]error:nil];
    }
    else
        return [self login:[[myAppDelegate Settings] userName] andPassWord:[[myAppDelegate Settings] passWord]];
}


-(NSDictionary *) loadListIndex:(NSString *)URL andMethod:(NSString *)Method
{
    NSHTTPURLResponse *response;
    NSData *responseData;
    
    NSMutableURLRequest *request;
    NSData *requestData;
    
    NSError *error;
    
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
                                                                             [myAppDelegate DBServerLink],
                                                                             URL]]
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:60];
    
    [request setHTTPMethod:Method];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    requestData = [[NSString stringWithFormat:@""]  dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    NSLog(@"Request:\n%@", [[NSString alloc] initWithFormat:@"%@", request] );
    NSLog(@"RequestData:\n%@", [[NSString alloc] initWithData:requestData  encoding: NSUTF8StringEncoding]);
    NSLog(@"RequestHeaders: \n%@\n", [request allHTTPHeaderFields]);
    
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"Respose:\n%@", [[NSString alloc] initWithData:responseData encoding: NSUTF8StringEncoding]);
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    if (error)
        return [parser objectWithString:[[NSString alloc] initWithFormat:@"{\"status_code\":\"%d\",\"message\":\"%@\"}", [error code], [error localizedDescription] ]error:nil];
    else
        return [parser objectWithString:[[NSString alloc] initWithData:responseData encoding: NSUTF8StringEncoding] error:nil];
}


-(NSDictionary *) setCoordinates:(double)latitude andLongitude:(double)longitude
{
    NSHTTPURLResponse   *response;
    NSData *responseData;
    
    NSMutableURLRequest *request;
    NSData *requestData;
    
    NSError *error;
    
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/users/coordinates/lat:%g/lng:%g",
                                                                             [myAppDelegate DBServerLink],
                                                                             latitude, longitude]]
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:60];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    requestData = [[NSString stringWithFormat:@""]  dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    
    NSLog(@"Request:\n%@", [[NSString alloc] initWithFormat:@"%@", request]);
    NSLog(@"RequestData:\n%@", [[NSString alloc] initWithData:requestData  encoding: NSUTF8StringEncoding]);
    NSLog(@"RequestHeaders: \n%@\n", [request allHTTPHeaderFields]);
    
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"Respose:\n%@", [[NSString alloc] initWithData:responseData  encoding: NSUTF8StringEncoding]);
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    if (error)
        return [parser objectWithString:[[NSString alloc] initWithFormat:@"{\"status_code\":\"%d\",\"message\":\"%@\"}", [error code], [error localizedDescription] ]error:nil];
    else
        return [parser objectWithString:[[NSString alloc] initWithData:responseData encoding: NSUTF8StringEncoding] error:nil];
}


-(NSDictionary *) getCoupon:(NSInteger)couponID
{
    NSHTTPURLResponse   *response;
    NSData *responseData;
    
    NSMutableURLRequest *request;
    NSData *requestData;
    
    NSError *error;
    
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/coupon/%d",
                                                                             [myAppDelegate DBServerLink],
                                                                             couponID]]
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:60];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    requestData = [[NSString stringWithFormat:@""]  dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
        
    NSLog(@"Request:\n%@", [[NSString alloc] initWithFormat:@"%@", request]);
    NSLog(@"RequestData:\n%@", [[NSString alloc] initWithData:requestData  encoding: NSUTF8StringEncoding]);
    NSLog(@"RequestHeaders: \n%@\n", [request allHTTPHeaderFields]);
    
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"Respose:\n%@", [[NSString alloc] initWithData:responseData  encoding: NSUTF8StringEncoding]);
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    if (error)
        return [parser objectWithString:[[NSString alloc] initWithFormat:@"{\"status_code\":\"%d\",\"message\":\"%@\"}", [error code], [error localizedDescription] ]error:nil];
    else
        return [parser objectWithString:[[NSString alloc] initWithData:responseData encoding: NSUTF8StringEncoding] error:nil];
}


-(NSDictionary *) setRadius:(NSInteger)radious
{
    NSHTTPURLResponse   *response;
    NSData *responseData;
    
    NSMutableURLRequest *request;
    NSData *requestData;
    
    NSError *error;
    
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/users/radius/%d",
                                                                             [myAppDelegate DBServerLink],
                                                                             radious]]
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:60];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    requestData = [[NSString stringWithFormat:@""]  dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    
    NSLog(@"Request:\n%@", [[NSString alloc] initWithFormat:@"%@", request]);
    NSLog(@"RequestData:\n%@", [[NSString alloc] initWithData:requestData  encoding: NSUTF8StringEncoding]);
    NSLog(@"RequestHeaders: \n%@\n", [request allHTTPHeaderFields]);
    
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"Respose:\n%@", [[NSString alloc] initWithData:responseData  encoding: NSUTF8StringEncoding]);
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    if (error)
        return [parser objectWithString:[[NSString alloc] initWithFormat:@"{\"status_code\":\"%d\",\"message\":\"%@\"}", [error code], [error localizedDescription] ]error:nil];
    else
        return [parser objectWithString:[[NSString alloc] initWithData:responseData encoding: NSUTF8StringEncoding] error:nil];
}


-(NSDictionary *) releaseCoupon:(NSInteger)couponID
{
    NSHTTPURLResponse   *response;
    NSData *responseData;
    
    NSMutableURLRequest *request;
    NSData *requestData;
    
    NSError *error;
    
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/coupons/reinsert/%d",
                                                                             [myAppDelegate DBServerLink],
                                                                             couponID]]
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:60];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    requestData = [[NSString stringWithFormat:@""]  dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    
    NSLog(@"Request:\n%@", [[NSString alloc] initWithFormat:@"%@", request]);
    NSLog(@"RequestData:\n%@", [[NSString alloc] initWithData:requestData  encoding: NSUTF8StringEncoding]);
    NSLog(@"RequestHeaders: \n%@\n", [request allHTTPHeaderFields]);
    
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"Respose:\n%@", [[NSString alloc] initWithData:responseData  encoding: NSUTF8StringEncoding]);
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    if (error)
        return [parser objectWithString:[[NSString alloc] initWithFormat:@"{\"status_code\":\"%d\",\"message\":\"%@\"}", [error code], [error localizedDescription] ]error:nil];
    else
        return [parser objectWithString:[[NSString alloc] initWithData:responseData encoding: NSUTF8StringEncoding] error:nil];
}

-(NSDictionary *) voteOffer:(NSString *)URL andOfferID:(NSInteger)offerID
{
    NSHTTPURLResponse   *response;
    NSData *responseData;
    
    NSMutableURLRequest *request;
    NSData *requestData;
    
    NSError *error;
    
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%d",
                                                                             [myAppDelegate DBServerLink],
                                                                             URL,
                                                                             offerID]]
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:60];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    requestData = [[NSString stringWithFormat:@""]  dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    
    NSLog(@"Request:\n%@", [[NSString alloc] initWithFormat:@"%@", request]);
    NSLog(@"RequestData:\n%@", [[NSString alloc] initWithData:requestData  encoding: NSUTF8StringEncoding]);
    NSLog(@"RequestHeaders: \n%@\n", [request allHTTPHeaderFields]);
    
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"Respose:\n%@", [[NSString alloc] initWithData:responseData  encoding: NSUTF8StringEncoding]);
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    if (error)
        return [parser objectWithString:[[NSString alloc] initWithFormat:@"{\"status_code\":\"%d\",\"message\":\"%@\"}", [error code], [error localizedDescription] ]error:nil];
    else
        return [parser objectWithString:[[NSString alloc] initWithData:responseData encoding: NSUTF8StringEncoding] error:nil];
}

















- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //[responseData setLength:0];
    NSLog(@"%@", response);
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //[responseData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    //[connection release];
    
    //NSString* responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    // NSLog(@"the html from google was %@", responseString);
    
    //[responseString release];
    
    //hack - start the next request here :|
    // DoHttpPostWithCookie* service = [[DoHttpPostWithCookie alloc] initWithViewController:self];
    //[service startHttpRequestWithCookie:self.cookies];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //  NSLog(@"something very bad happened here");
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSHTTPURLResponse *)
response {
    /*
     if (response != nil) {
     NSArray* authToken = [NSHTTPCookie
     cookiesWithResponseHeaderFields:[response allHeaderFields]
     forURL:[NSURL URLWithString:@""]];
     
     if ([authToken count] > 0) {
     [self setCookies:authToken];
     NSLog(@"cookies property %@", self.cookies);
     }
     }
     
     
     */
    return request;
}

- (void) returnHtmlFromPost:(NSString *)responseString
{
    //this is called from the new object we created when the "connectionDidFinishLoading" is complete
    // NSLog(@"got this response back from the post with cookies %@", responseString);
}



@end
