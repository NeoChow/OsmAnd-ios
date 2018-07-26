//
//  OATransportStopsLayer.h
//  OsmAnd
//
//  Created by Alexey on 14/07/2018.
//  Copyright © 2018 OsmAnd. All rights reserved.
//

#import "OASymbolMapLayer.h"
#import "OAContextMenuProvider.h"

#include <OsmAndCore/Map/VectorLinesCollection.h>
#include <OsmAndCore/Map/MapMarkersCollection.h>
#include <OsmAndCore/Data/TransportRoute.h>

#define kDefaultRouteColor 0xFFFF0000

@interface OATransportStopsLayer : OASymbolMapLayer<OAContextMenuProvider>

- (void) showStopsOnMap:(std::shared_ptr<OsmAnd::TransportRoute>)transportRoute;
- (void) hideStops;

@end
