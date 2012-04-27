//
//  NSString+CSS.m
//  DTCoreText
//
//  Created by Oliver Drobnik on 31.01.12.
//  Copyright (c) 2012 Drobnik.com. All rights reserved.
//

#import "DTCoreText.h"
#import "NSString+CSS.h"

@implementation NSString (CSS)

#pragma mark CSS

- (NSDictionary *)dictionaryOfCSSStyles
{
	// font-size:14px;
	NSScanner *scanner = [NSScanner scannerWithString:self];
	
	NSString *name = nil;
	NSString *value = nil;
	
	NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
	
	while ([scanner scanCSSAttribute:&name value:&value]) 
	{
		[tmpDict setObject:value forKey:name];
	}
	
	// converting to non-mutable costs 37.5% of method	
	//	return [NSDictionary dictionaryWithDictionary:tmpDict];
	return tmpDict;
}

- (CGFloat)pixelSizeOfCSSMeasureRelativeToCurrentTextSize:(CGFloat)textSize unit:(NSString**)outUnit
{
	NSError *error = nil;
	static NSRegularExpression *numericRegex = nil;
	if (!numericRegex) {
		numericRegex = [NSRegularExpression regularExpressionWithPattern:@"^([+-]?)(\\d*\\.\\d+|\\d+)([a-z]*|%?)" options:0 error:&error];
	}
	
	NSArray *matches = [numericRegex matchesInString:self options:NSMatchingAnchored range:(NSRange){0, self.length}];
	if (matches.count == 1) {
		NSTextCheckingResult *result = [matches lastObject];
		NSAssert([result numberOfRanges] == 4, @"Regular expression matching failes!");
		
		NSRange signRange = [result rangeAtIndex:1];
		NSRange valueRange = [result rangeAtIndex:2];
		NSRange unitRange = [result rangeAtIndex:3];
		
		BOOL negative = NO;
		if (signRange.length > 0) {
			negative = [@"-" isEqualToString:[self substringWithRange:signRange]];
		}
		
		float value = [[self substringWithRange:valueRange] floatValue];

		NSString *unit = nil;
		if (unitRange.length > 0) {
			unit = [self substringWithRange:unitRange];
			
			if ([@"%" isEqualToString:unit]) {
				value = value * textSize / 100.0f;
			} else if ([@"em" isEqualToString:unit]) {
				value = value * textSize;
			}
			
			if (outUnit) {
				*outUnit = unit;
			}
		}

		if (negative) value *= -1;
			
		return value;
	} else {
		return textSize;
	}
}
- (CGFloat)pixelSizeOfCSSMeasureRelativeToCurrentTextSize:(CGFloat)textSize
{
	return [self pixelSizeOfCSSMeasureRelativeToCurrentTextSize:textSize unit:nil];
}

- (NSArray *)arrayOfCSSShadowsWithCurrentTextSize:(CGFloat)textSize currentColor:(DTColor *)color
{
	NSScanner *scanner = [NSScanner scannerWithString:self];
	
	NSMutableCharacterSet *tokenEndSet = [[NSCharacterSet whitespaceAndNewlineCharacterSet] mutableCopy];
	[tokenEndSet addCharactersInString:@","];
	
	
	NSMutableArray *tmpArray = [NSMutableArray array];
	
	while (![scanner isAtEnd]) 
	{
		DTColor *shadowColor = nil;
		
		NSString *offsetXString = nil;
		NSString *offsetYString = nil;
		NSString *blurString = nil;
		
		if ([scanner scanHTMLColor:&shadowColor])
		{
			// format: <color> <length> <length> <length>?
			
			if ([scanner scanUpToCharactersFromSet:tokenEndSet intoString:&offsetXString])
			{
				if ([scanner scanUpToCharactersFromSet:tokenEndSet intoString:&offsetYString])
				{
					// blur is optional
					[scanner scanUpToCharactersFromSet:tokenEndSet intoString:&blurString];
					
					
					CGFloat offset_x = [offsetXString pixelSizeOfCSSMeasureRelativeToCurrentTextSize:textSize];
					CGFloat offset_y = [offsetYString pixelSizeOfCSSMeasureRelativeToCurrentTextSize:textSize];
					CGSize offset = CGSizeMake(offset_x, offset_y);
					CGFloat blur = [blurString pixelSizeOfCSSMeasureRelativeToCurrentTextSize:textSize];
					
					NSDictionary *shadowDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGSize:offset], @"Offset",
												[NSNumber numberWithFloat:blur], @"Blur",
												shadowColor, @"Color", nil];
					
					[tmpArray addObject:shadowDict];
				}
			}
		}
		else
		{
			// format: <length> <length> <length>? <color>?
			
			if ([scanner scanUpToCharactersFromSet:tokenEndSet intoString:&offsetXString])
			{
				if ([scanner scanUpToCharactersFromSet:tokenEndSet intoString:&offsetYString])
				{
					// blur is optional
					if (![scanner scanHTMLColor:&shadowColor])
					{
						if ([scanner scanUpToCharactersFromSet:tokenEndSet intoString:&blurString])
						{
							if (![scanner scanHTMLColor:&shadowColor])
							{
								
							}
						}
					}
					
					if (!shadowColor) 
					{
						// color is same as color attribute of style
						shadowColor = color;
					}
					
					CGFloat offset_x = [offsetXString pixelSizeOfCSSMeasureRelativeToCurrentTextSize:textSize];
					CGFloat offset_y = [offsetYString pixelSizeOfCSSMeasureRelativeToCurrentTextSize:textSize];
					CGSize offset = CGSizeMake(offset_x, offset_y);
					CGFloat blur = [blurString pixelSizeOfCSSMeasureRelativeToCurrentTextSize:textSize];
					
					NSDictionary *shadowDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGSize:offset], @"Offset",
												[NSNumber numberWithFloat:blur], @"Blur",
												shadowColor, @"Color", nil];
					
					[tmpArray addObject:shadowDict];
				}	
			}
		}
		
		// now there should be a comma
		if (![scanner scanString:@"," intoString:NULL])
		{
			break;
		}
	}		
	
	
	return tmpArray;
}

- (CGFloat)CSSpixelSize
{
	if ([self hasSuffix:@"px"])
	{
		return [self floatValue];
	}
	
	return [self floatValue];
}

@end
