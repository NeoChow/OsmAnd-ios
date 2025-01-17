//
//  OAAppData.h
//  OsmAnd
//
//  Created by Alexey Pelykh on 3/25/14.
//  Copyright (c) 2014 OsmAnd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OAObservable.h"
#import "OAMapViewState.h"
#import "OAMapSource.h"
#import "OAMapLayersConfiguration.h"
#import "OARTargetPoint.h"

@interface OAAppData : NSObject <NSCoding>

@property OAMapSource* lastMapSource;

@property OAMapSource* overlayMapSource;
@property OAMapSource* underlayMapSource;
@property (nonatomic) double overlayAlpha;
@property (nonatomic) double underlayAlpha;

@property (readonly) OAObservable* overlayMapSourceChangeObservable;
@property (readonly) OAObservable* underlayMapSourceChangeObservable;
@property (readonly) OAObservable* overlayAlphaChangeObservable;
@property (readonly) OAObservable* underlayAlphaChangeObservable;

@property (nonatomic) BOOL hillshade;
@property (readonly) OAObservable* hillshadeChangeObservable;
@property (readonly) OAObservable* hillshadeResourcesChangeObservable;

@property (nonatomic) BOOL mapillary;
@property (readonly) OAObservable* mapillaryChangeObservable;

@property (readonly) OAObservable* mapLayerChangeObservable;

@property (readonly) OAObservable* lastMapSourceChangeObservable;
- (OAMapSource *) lastMapSourceByResourceId:(NSString *)resourceId;

@property (readonly) OAMapViewState* mapLastViewedState;

@property (readonly) OAMapLayersConfiguration* mapLayersConfiguration;

@property (nonatomic) NSMutableArray *destinations;
@property (readonly) OAObservable* destinationsChangeObservable;
@property (readonly) OAObservable* destinationAddObservable;
@property (readonly) OAObservable* destinationRemoveObservable;
@property (readonly) OAObservable* destinationShowObservable;
@property (readonly) OAObservable* destinationHideObservable;

@property (nonatomic) OARTargetPoint *pointToStart;
@property (nonatomic) OARTargetPoint *pointToNavigate;
@property (nonatomic) NSArray<OARTargetPoint *> *intermediatePoints;

@property (readonly) OAObservable* applicationModeChangedObservable;

- (void) clearPointToStart;
- (void) clearPointToNavigate;

- (void) addIntermediatePoint:(OARTargetPoint *)point;
- (void) insertIntermediatePoint:(OARTargetPoint *)point index:(int)index;
- (void) deleteIntermediatePoint:(int)index;
- (void) clearIntermediatePoints;

- (void) backupTargetPoints;
- (void) restoreTargetPoints;
- (BOOL) restorePointToStart;

+ (OAAppData*) defaults;

- (void) setLastMapSourceVariant:(NSString *)variant;

@end
