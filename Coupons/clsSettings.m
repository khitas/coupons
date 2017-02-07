//
//  clsSettings.m
//  Coupons
//
//  Created by Kwstas Xytas on 10/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "clsSettings.h"
#import "AppDelegate.h"

@interface clsSettings ()

@end

@implementation clsSettings

@synthesize typesOrderBy;
@synthesize categoriesOrderBy;
@synthesize mapRadius;
@synthesize userName;
@synthesize passWord;
@synthesize rememberMe;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void) Load
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
	NSString *plistPath = [documentsPath stringByAppendingPathComponent:[(AppDelegate *)[[UIApplication sharedApplication] delegate] plistPath]];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) 
	{
		plistPath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
	}
	
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	NSString *errorDesc = nil;
	NSPropertyListFormat format;
    
	NSDictionary *settings = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
	
    if (!settings) 
	{
		NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
	}
    else {
        self.typesOrderBy = [[settings objectForKey:@"TypesOrderBy"] intValue];
        self.categoriesOrderBy = [[settings objectForKey:@"CategoriesOrderBy"] intValue];
        self.mapRadius = [[settings objectForKey:@"MapRadius"] intValue];
        self.userName = [settings objectForKey:@"UserName"];
        self.passWord = [settings objectForKey:@"PassWord"];
        self.rememberMe = [[settings objectForKey:@"RememberMe"] integerValue];
    }
}


-(void) Save
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
	NSString *plistPath = [documentsPath stringByAppendingPathComponent:[(AppDelegate *)[[UIApplication sharedApplication] delegate] plistPath]];
	
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects:
                                                                    [NSString stringWithFormat:@"%d", typesOrderBy],
                                                                    [NSString stringWithFormat:@"%d", categoriesOrderBy],
                                                                    [NSString stringWithFormat:@"%d", mapRadius],
                                                                    [NSString stringWithFormat:@"%@", userName],
                                                                    [NSString stringWithFormat:@"%@", passWord],
                                                                    [NSString stringWithFormat:@"%d", rememberMe],
                                                                    nil] forKeys:[NSArray arrayWithObjects:
                                                                                  @"TypesOrderBy",
                                                                                  @"CategoriesOrderBy",
                                                                                  @"MapRadius",
                                                                                  @"UserName",
                                                                                  @"PassWord",
                                                                                  @"RememberMe",
                                                                                  nil]];
	
	NSString *error = nil;
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
	
	if(plistData) 
	{
        [plistData writeToFile:plistPath atomically:YES];
    }
    else 
	{
        NSLog(@"Error in saveData: %@", error);
    }
}

@end
