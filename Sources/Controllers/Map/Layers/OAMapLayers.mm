//
//  OAMapLayers.m
//  OsmAnd
//
//  Created by Alexey Kulish on 08/06/2017.
//  Copyright © 2017 OsmAnd. All rights reserved.
//

#import "OAMapLayers.h"

#import "OAMapViewController.h"
#import "OAMapRendererView.h"
#import "OAPlugin.h"

@implementation OAMapLayers
{
    OAMapViewController *_mapViewController;
    OAMapRendererView *_mapView;
    
    NSMapTable<NSString *, OAMapLayer *> *_layers;
}

- (instancetype) initWithMapViewController:(OAMapViewController *)mapViewController
{
    self = [super init];
    if (self)
    {
        _mapViewController = mapViewController;
        _mapView = mapViewController.mapView;
        _layers = [NSMapTable strongToStrongObjectsMapTable];
    }
    return self;
}

- (void) createLayers
{
    _favoritesLayer = [[OAFavoritesLayer alloc] initWithMapViewController:_mapViewController baseOrder:-160000];
    [self addLayer:_favoritesLayer];

    _destinationsLayer = [[OADestinationsLayer alloc] initWithMapViewController:_mapViewController baseOrder:-207000];
    [self addLayer:_destinationsLayer];

    _myPositionLayer = [[OAMyPositionLayer alloc] initWithMapViewController:_mapViewController baseOrder:-206000];
    [self addLayer:_myPositionLayer];

    _contextMenuLayer = [[OAContextMenuLayer alloc] initWithMapViewController:_mapViewController baseOrder:-210000];
    [self addLayer:_contextMenuLayer];

    _poiLayer = [[OAPOILayer alloc] initWithMapViewController:_mapViewController];
    [self addLayer:_poiLayer];

    _hillshadeMapLayer = [[OAHillshadeMapLayer alloc] initWithMapViewController:_mapViewController layerIndex:4];
    [self addLayer:_hillshadeMapLayer];
    
    _overlayMapLayer = [[OAOverlayMapLayer alloc] initWithMapViewController:_mapViewController layerIndex:5];
    [self addLayer:_overlayMapLayer];

    _underlayMapLayer = [[OAUnderlayMapLayer alloc] initWithMapViewController:_mapViewController layerIndex:-5];
    [self addLayer:_underlayMapLayer];

    _gpxMapLayer = [[OAGPXLayer alloc] initWithMapViewController:_mapViewController layerIndex:9];
    [self addLayer:_gpxMapLayer];

    _gpxRecMapLayer = [[OAGPXLayer alloc] initWithMapViewController:_mapViewController layerIndex:12];
    [self addLayer:_gpxRecMapLayer];

    _routeMapLayer = [[OARouteLayer alloc] initWithMapViewController:_mapViewController layerIndex:15];
    [self addLayer:_routeMapLayer];

    _routePointsLayer = [[OARoutePointsLayer alloc] initWithMapViewController:_mapViewController baseOrder:-209000];
    [self addLayer:_routePointsLayer];
    
    [OAPlugin createLayers];
}

- (void) destroyLayers
{
    for (OAMapLayer *layer in _layers.objectEnumerator)
        [layer deinitLayer];

    [_layers removeAllObjects];
}

- (void) resetLayers
{
    for (OAMapLayer *layer in _layers.objectEnumerator)
        [layer resetLayer];
}

- (void) updateLayers
{
    for (OAMapLayer *layer in _layers.objectEnumerator)
        [layer updateLayer];
    
    [OAPlugin refreshLayers];
}

- (void) addLayer:(OAMapLayer *)layer
{
    [layer initLayer];
    [_layers setObject:layer forKey:layer.layerId];
}

- (void) showLayer:(NSString *)layerId
{
    OAMapLayer *layer = [_layers objectForKey:layerId];
    if (layer)
        [layer show];
}

- (void) hideLayer:(NSString *)layerId
{
    OAMapLayer *layer = [_layers objectForKey:layerId];
    if (layer)
        [layer hide];
}

- (void) onMapFrameRendered
{
    for (OAMapLayer *layer in _layers.objectEnumerator)
        [layer onMapFrameRendered];
}

@end
