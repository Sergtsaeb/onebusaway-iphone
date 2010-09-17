/**
 * Copyright (C) 2009 bdferris <bdferris@onebusaway.org>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "OBASearchController.h"
#import "OBARoute.h"
#import "OBAPlacemark.h"
#import "OBAAgencyWithCoverage.h"
#import "OBANavigationTargetAnnotation.h"
#import "OBAProgressIndicatorImpl.h"
#import "OBASphericalGeometryLibrary.h"
#import "OBAJsonDataSource.h"


static const float kSearchRadius = 400;


NSString * kOBASearchControllerSearchTypeParameter = @"OBASearchControllerSearchTypeParameter";
NSString * kOBASearchControllerSearchArgumentParameter = @"OBASearchControllerSearchArgumentParameter";
NSString * kOBASearchControllerSearchLocationParameter = @"OBASearchControllerSearchLocationParameter";


@interface OBASearchControllerFactory (Internal)

+ (OBANavigationTarget*) getNavigationTargetForSearchType:(OBASearchControllerSearchType)searchType;
+ (OBANavigationTarget*) getNavigationTargetForSearchType:(OBASearchControllerSearchType)searchType argument:(id)argument;

@end


#pragma mark OBASearchControllerResult implementation

@implementation OBASearchControllerResult

@synthesize searchType = _searchType;
@synthesize limitExceeded = _limitExceeded;
@synthesize outOfRange = _outOfRange;
@synthesize values = _values;
@synthesize additionalValues = _additionalValues;

+ (OBASearchControllerResult*) result {
	return [[[OBASearchControllerResult alloc] init] autorelease];
}

+ (OBASearchControllerResult*) resultFromList:(OBAListWithRangeAndReferencesV2*)list {
	OBASearchControllerResult * result = [[[OBASearchControllerResult alloc] init] autorelease];
	result.values = list.values;
	result.outOfRange = list.outOfRange;
	result.limitExceeded = list.limitExceeded;
	return result;
}

- (id) init {
	if( self = [super init] ) {
		_searchType = OBASearchControllerSearchTypeNone;
		_limitExceeded = FALSE;
		_outOfRange = FALSE;
		_values = [[NSArray alloc] init];
		_additionalValues = [[NSArray alloc] init];
	}
	return self;
}

- (void) dealloc {
	[_values release];
	[_additionalValues release];
	[super dealloc];
}

- (NSUInteger) count {
	return [_values count];
}

@end


#pragma mark OBASearchControllerFactory

@implementation OBASearchControllerFactory

+ (OBANavigationTarget*) getNavigationTargetForSearchNone {
	return [OBASearchControllerFactory getNavigationTargetForSearchType:OBASearchControllerSearchTypeNone];
}

+ (OBANavigationTarget*) getNavigationTargetForSearchLocationRegion:(MKCoordinateRegion)region {
	NSData * data = [NSData dataWithBytes:&region length:sizeof(MKCoordinateRegion)];	
	return [OBASearchControllerFactory getNavigationTargetForSearchType:OBASearchControllerSearchTypeRegion argument:data];
}

+ (OBANavigationTarget*) getNavigationTargetForSearchRoute:(NSString*)routeQuery {
	return [OBASearchControllerFactory getNavigationTargetForSearchType:OBASearchControllerSearchTypeRoute argument:routeQuery];
}

+ (OBANavigationTarget*) getNavigationTargetForSearchRouteStops:(NSString*)routeId {
	return [self getNavigationTargetForSearchType:OBASearchControllerSearchTypeRouteStops argument:routeId];
}

+ (OBANavigationTarget*) getNavigationTargetForSearchAddress:(NSString*)addressQuery {
	return [self getNavigationTargetForSearchType:OBASearchControllerSearchTypeAddress argument:addressQuery];	
}

+ (OBANavigationTarget*) getNavigationTargetForSearchPlacemark:(OBAPlacemark*)placemark {
	return [self getNavigationTargetForSearchType:OBASearchControllerSearchTypePlacemark argument:placemark];
}

+ (OBANavigationTarget*) getNavigationTargetForSearchStopCode:(NSString*)stopIdQuery {
	return [self getNavigationTargetForSearchType:OBASearchControllerSearchTypeStopId argument:stopIdQuery];	
}

+ (OBANavigationTarget*) getNavigationTargetForSearchAgenciesWithCoverage {
	return [self getNavigationTargetForSearchType:OBASearchControllerSearchTypeAgenciesWithCoverage];
}

@end


@implementation OBASearchControllerFactory (Internal)

+ (OBANavigationTarget*) getNavigationTargetForSearchType:(OBASearchControllerSearchType)searchType {
	return [self getNavigationTargetForSearchType:searchType argument:nil];
}

+ (OBANavigationTarget*) getNavigationTargetForSearchType:(OBASearchControllerSearchType)searchType argument:(id)argument {
	NSMutableDictionary * params = [NSMutableDictionary dictionary];
	[params setObject:[NSNumber numberWithInt:searchType] forKey:kOBASearchControllerSearchTypeParameter];

	if( argument )
		[params setObject:argument forKey:kOBASearchControllerSearchArgumentParameter];
    
	return [[[OBANavigationTarget alloc] initWithTarget:OBANavigationTargetTypeSearchResults parameters:params] autorelease];
}

@end
