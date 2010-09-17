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

#import "OBAListWithRangeAndReferencesV2.h"
#import "OBAArrivalsAndDeparturesForStop.h"
#import "OBAArrivalsAndDeparturesForStopV2.h"
#import "OBAStopsForRouteV2.h"


@interface OBAModelFactory : NSObject {
	NSManagedObjectContext * _context;
	NSMutableDictionary * _entityIdMappings;
}

- (id) initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

//- (NSArray*) getStopsFromJSONArray:(NSArray*)jsonArray error:(NSError**)error;
//- (NSArray*) getRoutesFromJSONArray:(NSArray*)jsonArray error:(NSError**)error;
- (NSArray*) getPlacemarksFromJSONObject:(id)jsonObject error:(NSError**)error;
//- (NSArray*) getAgenciesWithCoverageFromJson:(id)jsonArray error:(NSError**)error;
//- (NSArray*) getTripStatusElementsFromJSONArray:(NSArray*)jsonArray error:(NSError**)error;

- (OBAArrivalsAndDeparturesForStop*) getArrivalsAndDeparturesForStopFromJSON:(NSDictionary*)jsonDictionary error:(NSError**)error;

- (OBAListWithRangeAndReferencesV2*) getStopsV2FromJSON:(NSDictionary*)jsonDictionary error:(NSError**)error;
- (OBAListWithRangeAndReferencesV2*) getRoutesV2FromJSON:(NSDictionary*)jsonArray error:(NSError**)error;
- (OBAStopsForRouteV2*) getStopsForRouteV2FromJSON:(NSDictionary*)jsonDictionary error:(NSError**)error;
- (OBAListWithRangeAndReferencesV2*) getAgenciesWithCoverageV2FromJson:(id)jsonDictionary error:(NSError**)error;
- (OBAArrivalsAndDeparturesForStopV2*) getArrivalsAndDeparturesForStopV2FromJSON:(NSDictionary*)jsonDictionary error:(NSError**)error;


@end
