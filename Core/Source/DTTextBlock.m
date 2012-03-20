//
//  DTTextBlock.m
//  DTCoreText
//
//  Created by Oliver Drobnik on 04.03.12.
//  Copyright (c) 2012 Drobnik.com. All rights reserved.
//

#import "DTTextBlock.h"

@implementation DTTextBlock
{
	DTEdgeInsets _padding;
	DTColor *_backgroundColor;
}

#pragma mark Properties

@synthesize padding = _padding;
@synthesize backgroundColor = _backgroundColor;


#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super init];
	if (!self) return nil;
	
	self.padding  = [decoder decodeUIEdgeInsetsForKey:@"padding"];
	self.backgroundColor = [DTColor colorWithHexString:[decoder decodeObjectForKey:@"backgroundColor"]];
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeUIEdgeInsets:self.padding forKey:@"padding"];
	[encoder encodeObject:[self.backgroundColor htmlHexString] forKey:@"backgroundColor"];
}

@end
