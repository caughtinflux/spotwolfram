#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

#import <SpringBoard/SpringBoard.h>
#import <SpringBoard/SBSearchController.h>
#import <SpringBoard/SBSearchTableViewCell.h>
#import <SpringBoard/SBSearchView.h>

static NSIndexPath *_wikiCellIndexPath = nil;

#define kWAQueryURL @"http://wolframalpha.com/input/?i="

%hook SBSearchController

- (void)tableView:(UITableView *)arg1 willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([cell isKindOfClass:objc_getClass("SBSearchTableViewCell")] && ([((SBSearchTableViewCell *)cell).title hasSuffix:@"Wikipedia"])) {
		[_wikiCellIndexPath release];
		_wikiCellIndexPath = [indexPath copy];
		((SBSearchTableViewCell *)cell).title = @"Search Wolfram Alpha";
	}
	%orig();
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ((indexPath.row == _wikiCellIndexPath.row) && (indexPath.section == _wikiCellIndexPath.section)) {
		// CoreFoundation FTW!
		NSString *encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self.searchView.searchBar.text, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
		
		NSURL *URL = [NSURL URLWithString:[kWAQueryURL stringByAppendingString:encodedString]];
		
		[encodedString release];

		[(SpringBoard *)[UIApplication sharedApplication] applicationOpenURL:URL];
		
		[(SBSearchController *)self _deselect];
	}
	else {
		%orig();
	}
}

%end
