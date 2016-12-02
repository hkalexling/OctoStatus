//
//  GHStatusModel.m
//  OctoStatus
//
//  Created by Alex Ling on 1/12/2016.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

#import "GHStatusModel.h"

@implementation GHStatus

- (void) encodeWithCoder: (NSCoder *)aCoder {
	[aCoder encodeObject:self.status forKey:@"status"];
	[aCoder encodeObject:self.body forKey:@"body"];
	[aCoder encodeObject:self.time forKey:@"time"];
	[aCoder encodeObject:self.fetchTime forKey:@"fetchTime"];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self){
		self.status = [aDecoder decodeObjectForKey:@"status"];
		self.body = [aDecoder decodeObjectForKey:@"body"];
		self.time = [aDecoder decodeObjectForKey:@"time"];
		self.fetchTime = [aDecoder decodeObjectForKey:@"fetchTime"];
	}
	return self;
}

@end

@implementation GHStatusAPI

- (void) encodeWithCoder: (NSCoder *)aCoder {
	[aCoder encodeObject:self.statusURL forKey:@"statusURL"];
	[aCoder encodeObject:self.messagesURL forKey:@"messagesURL"];
	[aCoder encodeObject:self.lastMessageURL forKey:@"lastMessageURL"];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self){
		self.statusURL = [aDecoder decodeObjectForKey:@"statusURL"];
		self.messagesURL = [aDecoder decodeObjectForKey:@"messagesURL"];
		self.lastMessageURL = [aDecoder decodeObjectForKey:@"lastMessageURL"];
	}
	return self;
}

@end
