#import "DTCoreTextConstants.h"

#import <ImageIO/ImageIO.h>


// standard options

NSString *NSBaseURLDocumentOption = @"NSBaseURLDocumentOption";
NSString *NSTextEncodingNameDocumentOption = @"NSTextEncodingNameDocumentOption";
NSString *NSTextSizeMultiplierDocumentOption = @"NSTextSizeMultiplierDocumentOption";
NSString *NSAttachmentAttributeName = @"NSAttachmentAttributeName";

// custom options

NSString *DTMaxImageSize = @"DTMaxImageSize";
NSString *DTDefaultFontFamily = @"DTDefaultFontFamily";
NSString *DTDefaultTextColor = @"DTDefaultTextColor";
NSString *DTDefaultLinkColor = @"DTDefaultLinkColor";
NSString *DTDefaultLinkDecoration = @"DTDefaultLinkDecoration";
NSString *DTDefaultTextAlignment = @"DTDefaultTextAlignment";
NSString *DTDefaultLineHeightMultiplier = @"DTDefaultLineHeightMultiplier";
NSString *DTDefaultFirstLineHeadIndent = @"DTDefaultFirstLineHeadIndent";
NSString *DTDefaultHeadIndent = @"DTDefaultHeadIndent";
NSString *DTDefaultListIndent = @"DTDefaultListIndent";

NSString *DTDefaultStyleSheet = @"DTDefaultStyleSheet";

NSString *DTTagStartHandlers = @"DTTagStartHandlers";
NSString *DTTagEndHandlers = @"DTTagEndHandlers";

NSString *DTFilterElementsCallback = @"DTFilterElementsCallback";

// attributed string attribute constants

NSString *DTTextListsAttribute = @"DTTextLists";
NSString *DTAttachmentParagraphSpacingAttribute = @"DTAttachmentParagraphSpacing";
NSString *DTLinkAttribute = @"DTLink";
NSString *DTGUIDAttribute = @"DTGUID";
NSString *DTHeaderLevelAttribute = @"DTHeaderLevel";
NSString *DTPreserveNewlinesAttribute = @"DTPreserveNewlines";
NSString *DTStrikeOutAttribute = @"DTStrikeOut";
NSString *DTBackgroundColorAttribute = @"DTBackgroundColor";
NSString *DTShadowsAttribute = @"DTShadows";
NSString *DTHorizontalRuleStyleAttribute = @"DTHorizontalRuleStyle";
NSString *DTTextBlocksAttribute = @"DTTextBlocks";
NSString *DTFieldAttribute = @"DTField";


NSString *DTHTMLStartPositionAttribute = @"DTHTMLStartPositionAttribute";
NSString *DTHTMLEndPositionAttribute   = @"DTHTMLEndPositionAttribute";


CGSize DTSizeOfImageAtURL(NSURL *url)
{
	CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
	if (imageSource == NULL) {
		return CGSizeZero;
	}
	
	CGSize size = CGSizeMake(0.0, 0.0);
	CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
	if (imageProperties != NULL) {
		CFNumberRef widthNum  = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
		if (widthNum != NULL) {
			CFNumberGetValue(widthNum, kCFNumberFloatType, &size.width);
		}
		
		CFNumberRef heightNum = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
		if (heightNum != NULL) {
			CFNumberGetValue(heightNum, kCFNumberFloatType, &size.height);
		}
		
		CFRelease(imageProperties);
	}
	
	return size;
}