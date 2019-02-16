//
//  OAOsmEditingPlugin.m
//  OsmAnd
//
//  Created by Paul on 1/18/19.
//  Copyright © 2019 OsmAnd. All rights reserved.
//

#import "OAOsmEditingPlugin.h"

#import "OsmAndApp.h"
#import "OAAppSettings.h"
#import "OATextInfoWidget.h"
#import "OAApplicationMode.h"
#import "OAIAPHelper.h"
#import "OAMapPanelViewController.h"
#import "OAMapHudViewController.h"
#import "OAMapInfoController.h"
#import "Localization.h"
#import "OAUtilities.h"
#import "PXAlertView.h"
#import "OADestinationsHelper.h"
#import "OADestination.h"
#import "OARoutingHelper.h"
#import "OAMapViewController.h"
#import "OANativeUtilities.h"
#import "OAOsmEditsLayer.h"
#import "OAOsmEditsDBHelper.h"
#import "OAOpenStreetMapPoint.h"
#import "OANode.h"
#import "OAMapViewController.h"
#import "OARootViewController.h"
#import "OAMapLayers.h"
#import "OAOpenStreetMapLocalUtil.h"
#import "OAOsmBugsLocalUtil.h"

#include <OsmAndCore.h>
#include <OsmAndCore/Utilities.h>

#define PLUGIN_ID kInAppId_Addon_OsmEditing

@interface OAOsmEditingPlugin ()

@property (nonatomic) OsmAndAppInstance app;
@property (nonatomic) OAAppSettings *settings;
@property (nonatomic) OADestinationsHelper *helper;
@property (nonatomic) OAMapViewController *mapViewController;

@end

@implementation OAOsmEditingPlugin
{
    OAOsmEditsDBHelper *_editsDb;
}

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        _app = [OsmAndApp instance];
        _settings = [OAAppSettings sharedManager];
        _helper = [OADestinationsHelper instance];
        _mapViewController = [OARootViewController instance].mapPanel.mapViewController;
        _editsDb = [OAOsmEditsDBHelper sharedDatabase];
        _localOsmUtil = [[OAOpenStreetMapLocalUtil alloc] init];
        _localBugsUtil = [[OAOsmBugsLocalUtil alloc] init];
    }
    return self;
}

+ (NSString *) getId
{
    return PLUGIN_ID;
}

- (void) registerLayers
{
    
}

- (void) updateLayers
{
    if (!_mapViewController)
        _mapViewController = [OARootViewController instance].mapPanel.mapViewController;
    if ([self isActive])
    {
        
        //    if (osmBugsLayer == null) {
        //        registerLayers(activity);
        //    }
        
        [_mapViewController.mapLayers showLayer:kOsmEditsLayerId];
        
        //    if (mapView.getLayers().contains(osmBugsLayer) != settings.SHOW_OSM_BUGS.get()) {
        //        if (settings.SHOW_OSM_BUGS.get()) {
        //            mapView.addLayer(osmBugsLayer, 2);
        //        } else {
        //            mapView.removeLayer(osmBugsLayer);
        //        }
        //    }
    }
    else
    {
        //    if (osmBugsLayer != null) {
        //        mapView.removeLayer(osmBugsLayer);
        //    }
        [_mapViewController.mapLayers hideLayer:kOsmEditsLayerId];
        
    }
}


@end
