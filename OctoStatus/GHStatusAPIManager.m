//
//  GHStatusAPIManager.m
//  OctoStatus
//
//  Created by Alex Ling on 1/12/2016.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

#import "GHStatusAPIManager.h"

@implementation GHStatusAPIManager

+ (instancetype) sharedManager {
	static GHStatusAPIManager *manager;
	static dispatch_once_t token;
	dispatch_once(&token, ^{
		manager = [GHStatusAPIManager new];
	});
	return manager;
}

- (RACSignal *)status {
	return [[self listAPI] flattenMap:^__kindof RACSignal * _Nullable(GHStatusAPI *api) {
		NSString *URL = api.statusURL;
		return [[self jsonFromURL:URL parameters:nil] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
			
			return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
				
				GHStatus *status = [GHStatus new];
				if (value){
					status.status = [value objectForKey:@"status"];
					status.body = [value objectForKey:@"body"];
					ISO8601DateFormatter *formatter = [ISO8601DateFormatter new];
					status.time = [formatter dateFromString:[value objectForKey:@"last_updated"]];
				}
				[subscriber sendNext:status];
				[subscriber sendCompleted];
				
				return nil;
			}];
		}];
	}];
}

- (RACSignal *)lastMessage {
	return [[self listAPI] flattenMap:^__kindof RACSignal * _Nullable(GHStatusAPI *api) {
		NSString *URL = api.lastMessageURL;
		return [[self jsonFromURL:URL parameters:nil] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
			
			return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
				
				GHStatus *status = [GHStatus new];
				if (value){
					status.status = [value objectForKey:@"status"];
					status.body = [value objectForKey:@"body"];
					ISO8601DateFormatter *formatter = [ISO8601DateFormatter new];
					status.time = [formatter dateFromString:[value objectForKey:@"created_on"]];					
				}
				[subscriber sendNext:status];
				[subscriber sendCompleted];
				
				return nil;
			}];
		}];
	}];
}

- (RACSignal *)messages {
	return [[self listAPI] flattenMap:^__kindof RACSignal * _Nullable(GHStatusAPI *api) {
		NSString *URL = api.messagesURL;
		return [[self jsonFromURL:URL parameters:nil] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
			
			return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
				
				NSArray *ary = (NSArray *)value;
				if (ary){
					for (id status in ary){
						GHStatus *statusObj = [GHStatus new];
						statusObj.status = [status objectForKey:@"status"];
						statusObj.body = [status objectForKey:@"body"];
						ISO8601DateFormatter *formatter = [ISO8601DateFormatter new];
						statusObj.time = [formatter dateFromString:[status objectForKey:@"created_on"]];
						[subscriber sendNext:statusObj];
					}
				}
				
				[subscriber sendCompleted];
				
				return nil;
			}];
		}];
	}];
}

- (RACSignal *)listAPI {
	
	GHStatusAPI *api = [Utility api];
	if (api){
		return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
			[subscriber sendNext:api];
			[subscriber sendCompleted];
			return nil;
		}];
	}
	return [[self jsonFromURL:@"https://status.github.com/api.json" parameters:nil] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
		return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
			
			GHStatusAPI *api = [GHStatusAPI new];
			if (value){
				api.statusURL = [value objectForKey:@"status_url"];
				api.messagesURL = [value objectForKey:@"messages_url"];
				api.lastMessageURL = [value objectForKey:@"last_message_url"];
				
				[Utility saveAPI:api];
			}
			[subscriber sendNext:api];
			[subscriber sendCompleted];
			
			return nil;
		}];
	}];
	
}


# pragma mark - Utility

- (RACSignal *)jsonFromURL:(NSString *)url parameters:(NSDictionary *)parameters {
	return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
		AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
		[manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
		manager.responseSerializer = [AFJSONResponseSerializer serializer];
		
		[manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			if (responseObject){
				[subscriber sendNext:responseObject];
				[subscriber sendCompleted];
			}
		} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			[subscriber sendError:error];
		}];
		return nil;
	}];
}

@end
