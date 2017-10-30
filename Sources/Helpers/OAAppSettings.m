//
//  OADebugSettings.m
//  OsmAnd
//
//  Created by AntonRogachevskiy on 10/16/14.
//  Copyright (c) 2014 OsmAnd. All rights reserved.
//

#import "OAAppSettings.h"
#import "OsmAndApp.h"
#import "Localization.h"
#import "OAUtilities.h"

@interface OAMetricsConstant()

@property (nonatomic) EOAMetricsConstant mc;

@end

@implementation OAMetricsConstant

+ (instancetype)withMetricConstant:(EOAMetricsConstant)mc
{
    OAMetricsConstant *obj = [[OAMetricsConstant alloc] init];
    if (obj)
    {
        obj.mc = mc;
    }
    return obj;
}

+ (NSString *) toHumanString:(EOAMetricsConstant)mc
{
    switch (mc)
    {
        case KILOMETERS_AND_METERS:
            return OALocalizedString(@"si_km_m");
        case MILES_AND_FEET:
            return OALocalizedString(@"si_mi_feet");
        case MILES_AND_METERS:
            return OALocalizedString(@"si_mi_meters");
        case MILES_AND_YARDS:
            return OALocalizedString(@"si_mi_yard");
        case NAUTICAL_MILES:
            return OALocalizedString(@"si_nm");
            
        default:
            return @"";
    }
}

+ (NSString *) toTTSString:(EOAMetricsConstant)mc
{
    switch (mc)
    {
        case KILOMETERS_AND_METERS:
            return @"km-m";
        case MILES_AND_FEET:
            return @"mi-f";
        case MILES_AND_METERS:
            return @"mi-m";
        case MILES_AND_YARDS:
            return @"mi-y";
        case NAUTICAL_MILES:
            return @"nm";
            
        default:
            return @"";
    }
}

@end

@interface OASpeedConstant ()

@property (nonatomic) EOASpeedConstant sc;
@property (nonatomic) NSString *key;
@property (nonatomic) NSString *descr;

@end

@implementation OASpeedConstant

+ (instancetype) withSpeedConstant:(EOASpeedConstant)sc
{
    OASpeedConstant *obj = [[OASpeedConstant alloc] init];
    if (obj)
    {
        obj.sc = sc;
        obj.key = [self.class toShortString:sc];
        obj.descr = [self.class toHumanString:sc];
    }
    return obj;
}

+ (NSArray<OASpeedConstant *> *) values
{
    return @[ [OASpeedConstant withSpeedConstant:KILOMETERS_PER_HOUR],
              [OASpeedConstant withSpeedConstant:MILES_PER_HOUR],
              [OASpeedConstant withSpeedConstant:METERS_PER_SECOND],
              [OASpeedConstant withSpeedConstant:MINUTES_PER_MILE],
              [OASpeedConstant withSpeedConstant:MINUTES_PER_KILOMETER],
              [OASpeedConstant withSpeedConstant:NAUTICALMILES_PER_HOUR] ];
}

+ (NSString *) toHumanString:(EOASpeedConstant)sc
{
    switch (sc)
    {
        case KILOMETERS_PER_HOUR:
            return OALocalizedString(@"si_kmh");
        case MILES_PER_HOUR:
            return OALocalizedString(@"si_mph");
        case METERS_PER_SECOND:
            return OALocalizedString(@"si_m_s");
        case MINUTES_PER_MILE:
            return OALocalizedString(@"si_min_m");
        case MINUTES_PER_KILOMETER:
            return OALocalizedString(@"si_min_km");
        case NAUTICALMILES_PER_HOUR:
            return OALocalizedString(@"si_nm_h");
            
        default:
            return nil;
    }
}

+ (NSString *) toShortString:(EOASpeedConstant)sc
{
    switch (sc)
    {
        case KILOMETERS_PER_HOUR:
            return OALocalizedString(@"units_kmh");
        case MILES_PER_HOUR:
            return OALocalizedString(@"units_mph");
        case METERS_PER_SECOND:
            return OALocalizedString(@"m_s");
        case MINUTES_PER_MILE:
            return OALocalizedString(@"min_mile");
        case MINUTES_PER_KILOMETER:
            return OALocalizedString(@"min_km");
        case NAUTICALMILES_PER_HOUR:
            return OALocalizedString(@"nm_h");
            
        default:
            return nil;
    }
}

@end

@interface OADrivingRegion()

@property (nonatomic) EOADrivingRegion region;

@end

@implementation OADrivingRegion

+ (instancetype)withRegion:(EOADrivingRegion)region
{
    OADrivingRegion *obj = [[OADrivingRegion alloc] init];
    if (obj)
    {
        obj.region = region;
    }
    return obj;
}

+ (BOOL) isLeftHandDriving:(EOADrivingRegion)region
{
    return region == DR_UK_AND_OTHERS || region == DR_JAPAN || region == DR_AUSTRALIA;
}

+ (BOOL) isAmericanSigns:(EOADrivingRegion)region
{
    return region == DR_US || region == DR_CANADA || region == DR_AUSTRALIA;
}

+ (EOAMetricsConstant) getDefMetrics:(EOADrivingRegion)region
{
    switch (region)
    {
        case DR_EUROPE_ASIA:
            return KILOMETERS_AND_METERS;
        case DR_US:
            return MILES_AND_FEET;
        case DR_CANADA:
            return KILOMETERS_AND_METERS;
        case DR_UK_AND_OTHERS:
            return MILES_AND_METERS;
        case DR_JAPAN:
            return KILOMETERS_AND_METERS;
        case DR_AUSTRALIA:
            return KILOMETERS_AND_METERS;
            
        default:
            return KILOMETERS_AND_METERS;
    }
}

+ (NSString *) getName:(EOADrivingRegion)region
{
    switch (region) {
        case DR_EUROPE_ASIA:
            return OALocalizedString(@"driving_region_europe_asia");
        case DR_US:
            return OALocalizedString(@"driving_region_us");
        case DR_CANADA:
            return OALocalizedString(@"driving_region_canada");
        case DR_UK_AND_OTHERS:
            return OALocalizedString(@"driving_region_uk");
        case DR_JAPAN:
            return OALocalizedString(@"driving_region_japan");
        case DR_AUSTRALIA:
            return OALocalizedString(@"driving_region_australia");
            
        default:
            return @"";
    }
}

+ (NSString *) getDescription:(EOADrivingRegion)region
{
    return [OADrivingRegion isLeftHandDriving:region] ? OALocalizedString(@"left_side_navigation") : [NSString stringWithFormat:@"%@, %@", OALocalizedString(@"right_side_navigation"), [[OAMetricsConstant toHumanString:[OADrivingRegion getDefMetrics:region]] lowerCase]];
}

+ (EOADrivingRegion) getDefaultRegion
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    BOOL isMetricSystem = [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue] && ![locale.localeIdentifier isEqualToString:@"en_GB"];
    
    if (!countryCode) {
        return DR_EUROPE_ASIA;
    }
    countryCode = [countryCode lowercaseString];
    if ([countryCode isEqualToString:@"us"]) {
        return DR_US;
    } else if ([countryCode isEqualToString:@"ca"]) {
        return DR_CANADA;
    } else if ([countryCode isEqualToString:@"jp"]) {
        return DR_JAPAN;
    } else if ([countryCode isEqualToString:@"au"]) {
        return DR_AUSTRALIA;
    } else if (!isMetricSystem) {
        return DR_UK_AND_OTHERS;
    }
    return DR_EUROPE_ASIA;
}

@end

@interface OAAutoZoomMap ()

@property (nonatomic) EOAAutoZoomMap autoZoomMap;
@property (nonatomic) float coefficient;
@property (nonatomic) NSString *name;
@property (nonatomic) float maxZoom;

@end

@implementation OAAutoZoomMap

+ (instancetype) withAutoZoomMap:(EOAAutoZoomMap)autoZoomMap
{
    OAAutoZoomMap *obj = [[OAAutoZoomMap alloc] init];
    if (obj)
    {
        obj.autoZoomMap = autoZoomMap;
        obj.coefficient = [self.class getCoefficient:autoZoomMap];
        obj.name = [self.class getName:autoZoomMap];
        obj.maxZoom = [self.class getMaxZoom:autoZoomMap];
    }
    return obj;
}

+ (NSArray<OAAutoZoomMap *> *) values
{
    return @[ [OAAutoZoomMap withAutoZoomMap:AUTO_ZOOM_MAP_FARTHEST],
              [OAAutoZoomMap withAutoZoomMap:AUTO_ZOOM_MAP_FAR],
              [OAAutoZoomMap withAutoZoomMap:AUTO_ZOOM_MAP_CLOSE] ];
}

+ (float) getCoefficient:(EOAAutoZoomMap)autoZoomMap
{
    switch (autoZoomMap)
    {
        case AUTO_ZOOM_MAP_FARTHEST:
            return 1.f;
        case AUTO_ZOOM_MAP_FAR:
            return 1.4f;
        case AUTO_ZOOM_MAP_CLOSE:
            return 2.f;
        default:
            return 0;
    }
}

+ (NSString *) getName:(EOAAutoZoomMap)autoZoomMap
{
    switch (autoZoomMap)
    {
        case AUTO_ZOOM_MAP_FARTHEST:
            return OALocalizedString(@"auto_zoom_farthest");
        case AUTO_ZOOM_MAP_FAR:
            return OALocalizedString(@"auto_zoom_far");
        case AUTO_ZOOM_MAP_CLOSE:
            return OALocalizedString(@"auto_zoom_close");
        default:
            return nil;
    }
}

+ (float) getMaxZoom:(EOAAutoZoomMap)autoZoomMap
{
    switch (autoZoomMap)
    {
        case AUTO_ZOOM_MAP_FARTHEST:
            return 15.5f;
        case AUTO_ZOOM_MAP_FAR:
            return 17.f;
        case AUTO_ZOOM_MAP_CLOSE:
            return 19.f;
        default:
            return 0;
    }
}

@end

@interface OAMapMarkersMode ()

@property (nonatomic) EOAMapMarkersMode mode;
@property (nonatomic) NSString *name;

@end

@implementation OAMapMarkersMode

+ (instancetype) withMode:(EOAMapMarkersMode)mode
{
    OAMapMarkersMode *obj = [[OAMapMarkersMode alloc] init];
    if (obj)
    {
        obj.mode = mode;
        obj.name = [self.class getName:mode];
    }
    return obj;
}

+ (NSArray<OAAutoZoomMap *> *) possibleValues
{
    return @[ [OAMapMarkersMode withMode:MAP_MARKERS_MODE_TOOLBAR],
              [OAMapMarkersMode withMode:MAP_MARKERS_MODE_WIDGETS],
              [OAMapMarkersMode withMode:MAP_MARKERS_MODE_NONE] ];
}

+ (NSString *) getName:(EOAMapMarkersMode)mode
{
    switch (mode)
    {
        case MAP_MARKERS_MODE_TOOLBAR:
            return OALocalizedString(@"shared_string_topbar");
        case MAP_MARKERS_MODE_WIDGETS:
            return OALocalizedString(@"shared_string_widgets");
        case MAP_MARKERS_MODE_NONE:
            return OALocalizedString(@"map_settings_none");
        default:
            return nil;
    }
}

@end

@interface OAProfileSetting ()

@property (nonatomic, readonly) OAApplicationMode *appMode;
@property (nonatomic) NSString *key;
@property (nonatomic) NSMapTable<OAApplicationMode *, NSObject *> *cachedValues;
@property (nonatomic) NSMapTable<OAApplicationMode *, NSObject *> *defaultValues;

+ (instancetype) withKey:(NSString *)key;
- (NSObject *) getValue:(OAApplicationMode *)mode;
- (void) setValue:(NSObject *)value mode:(OAApplicationMode *)mode;

@end

@implementation OAProfileSetting

- (OAApplicationMode *) appMode
{
    return [OAAppSettings sharedManager].applicationMode;
}

- (NSString *) getModeKey:(NSString *)key mode:(OAApplicationMode *)mode
{
    return [NSString stringWithFormat:@"%@_%@", key, mode.stringKey];
}

+ (instancetype) withKey:(NSString *)key
{
    OAProfileSetting *obj = [[OAProfileSetting alloc] init];
    if (obj)
    {
        obj.key = key;
        obj.cachedValues = [NSMapTable strongToStrongObjectsMapTable];
    }

    return obj;
}

- (NSObject *) getValue:(OAApplicationMode *)mode
{
    NSObject *cachedValue = [self.cachedValues objectForKey:mode];
    if (!cachedValue)
    {
        NSString *key = [self getModeKey:self.key mode:mode];
        cachedValue = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        [self.cachedValues setObject:cachedValue forKey:mode];
    }
    if (!cachedValue)
    {
        cachedValue = [self getProfileDefaultValue:mode];
    }
    return cachedValue;
}

- (void) setValue:(NSObject *)value mode:(OAApplicationMode *)mode
{
    [self.cachedValues setObject:value forKey:mode];
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:[self getModeKey:self.key mode:mode]];
}

- (void) setModeDefaultValue:(NSObject *)defValue mode:(OAApplicationMode *)mode
{
    if (!self.defaultValues) {
        self.defaultValues = [NSMapTable strongToStrongObjectsMapTable];
    }
    [self.defaultValues setObject:defValue forKey:mode];
}

- (NSObject *) getProfileDefaultValue:(OAApplicationMode *)mode
{
    if (self.defaultValues && [self.defaultValues objectForKey:mode])
        return [self.defaultValues objectForKey:mode];
    
    OAApplicationMode *pt = mode.parent;
    if (pt)
        return [self getProfileDefaultValue:pt];

    return nil;
}

- (void) resetToDefault
{
}

@end

@interface OAProfileBoolean ()

@property (nonatomic) BOOL defValue;

@end

@implementation OAProfileBoolean

+ (instancetype) withKey:(NSString *)key defValue:(BOOL)defValue
{
    OAProfileBoolean *obj = [[OAProfileBoolean alloc] init];
    if (obj)
    {
        obj.key = key;
        obj.defValue = defValue;
    }
    
    return obj;
}

- (BOOL) get
{
    return [self get:self.appMode];
}

- (void) set:(BOOL)boolean
{
    [self set:boolean mode:self.appMode];
}

- (BOOL) get:(OAApplicationMode *)mode
{
    NSObject *value = [self getValue:mode];
    if (value)
        return ((NSNumber *)value).boolValue;
    else
        return self.defValue;
}

- (void) set:(BOOL)boolean mode:(OAApplicationMode *)mode
{
    [self setValue:@(boolean) mode:mode];
}

- (void) resetToDefault
{
    BOOL defaultValue = self.defValue;
    NSObject *pDefault = [self getProfileDefaultValue:self.appMode];
    if (pDefault)
        defaultValue = ((NSNumber *)pDefault).boolValue;
    
    [self set:defaultValue];
}

@end

@interface OAProfileInteger ()

@property (nonatomic) int defValue;

@end

@implementation OAProfileInteger

+ (instancetype) withKey:(NSString *)key defValue:(int)defValue
{
    OAProfileInteger *obj = [[OAProfileInteger alloc] init];
    if (obj)
    {
        obj.key = key;
        obj.defValue = defValue;
    }
    
    return obj;
}

- (int) get
{
    return [self get:self.appMode];
}

- (void) set:(int)integer
{
    [self set:integer mode:self.appMode];
}

- (int) get:(OAApplicationMode *)mode
{
    NSObject *value = [self getValue:mode];
    if (value)
        return ((NSNumber *)value).intValue;
    else
        return self.defValue;
}

- (void) set:(int)integer mode:(OAApplicationMode *)mode
{
    [self setValue:@(integer) mode:mode];
}

- (void) resetToDefault
{
    int defaultValue = self.defValue;
    NSObject *pDefault = [self getProfileDefaultValue:self.appMode];
    if (pDefault)
        defaultValue = ((NSNumber *)pDefault).intValue;
    
    [self set:defaultValue];
}

@end

@interface OAProfileString ()

@property (nonatomic) NSString *defValue;

@end

@implementation OAProfileString

+ (instancetype) withKey:(NSString *)key defValue:(NSString *)defValue
{
    OAProfileString *obj = [[OAProfileString alloc] init];
    if (obj)
    {
        obj.key = key;
        obj.defValue = defValue;
    }
    
    return obj;
}

- (NSString *) get
{
    return [self get:self.appMode];
}

- (void) set:(NSString *)string
{
    [self set:string  mode:self.appMode];
}

- (NSString *) get:(OAApplicationMode *)mode
{
    NSObject *value = [self getValue:mode];
    if (value)
        return (NSString *)value;
    else
        return self.defValue;
}

- (void) set:(NSString *)string mode:(OAApplicationMode *)mode
{
    [self setValue:string mode:mode];
}

- (void) resetToDefault
{
    NSString *defaultValue = self.defValue;
    NSObject *pDefault = [self getProfileDefaultValue:self.appMode];
    if (pDefault)
        defaultValue = (NSString *)pDefault;
    
    [self set:defaultValue];
}

@end

@interface OAProfileDouble ()

@property (nonatomic) double defValue;

@end

@implementation OAProfileDouble

+ (instancetype) withKey:(NSString *)key defValue:(double)defValue
{
    OAProfileDouble *obj = [[OAProfileDouble alloc] init];
    if (obj)
    {
        obj.key = key;
        obj.defValue = defValue;
    }
    
    return obj;
}

- (double) get
{
    return [self get:self.appMode];
}

- (void) set:(double)dbl
{
    [self set:dbl mode:self.appMode];
}

- (double) get:(OAApplicationMode *)mode
{
    NSObject *value = [self getValue:mode];
    if (value)
        return ((NSNumber *)value).doubleValue;
    else
        return self.defValue;
}

- (void) set:(double)dbl mode:(OAApplicationMode *)mode
{
    [self setValue:@(dbl) mode:mode];
}

- (void) resetToDefault
{
    double defaultValue = self.defValue;
    NSObject *pDefault = [self getProfileDefaultValue:self.appMode];
    if (pDefault)
        defaultValue = ((NSNumber *)pDefault).doubleValue;
    
    [self set:defaultValue];
}

@end

@interface OAProfileAutoZoomMap ()

@property (nonatomic) EOAAutoZoomMap defValue;

@end

@implementation OAProfileAutoZoomMap

@dynamic defValue;

+ (instancetype) withKey:(NSString *)key defValue:(EOAAutoZoomMap)defValue
{
    return [super withKey:key defValue:defValue];
}

- (EOAAutoZoomMap) get
{
    return [super get];
}

- (void) set:(EOAAutoZoomMap)autoZoomMap
{
    [super set:autoZoomMap];
}

- (EOAAutoZoomMap) get:(OAApplicationMode *)mode
{
    return [super get:mode];
}

- (void) set:(EOAAutoZoomMap)autoZoomMap mode:(OAApplicationMode *)mode
{
    [super set:autoZoomMap mode:mode];
}

- (void) resetToDefault
{
    EOAAutoZoomMap defaultValue = self.defValue;
    NSObject *pDefault = [self getProfileDefaultValue:self.appMode];
    if (pDefault)
        defaultValue = (EOAAutoZoomMap)((NSNumber *)pDefault).intValue;
    
    [self set:defaultValue];
}

@end

@interface OAProfileSpeedConstant ()

@property (nonatomic) EOASpeedConstant defValue;

@end

@implementation OAProfileSpeedConstant

@dynamic defValue;

+ (instancetype) withKey:(NSString *)key defValue:(EOASpeedConstant)defValue
{
    return [super withKey:key defValue:defValue];
}

- (EOASpeedConstant) get
{
    return [super get];
}

- (void) set:(EOASpeedConstant)speedConstant
{
    [super set:speedConstant];
}

- (EOASpeedConstant) get:(OAApplicationMode *)mode
{
    return [super get:mode];
}

- (void) set:(EOASpeedConstant)speedConstant mode:(OAApplicationMode *)mode
{
    [super set:speedConstant mode:mode];
}

- (NSObject *)getProfileDefaultValue:(OAApplicationMode *)mode
{
    EOAMetricsConstant mc = [OAAppSettings sharedManager].metricSystem;
    if ([mode isDerivedRoutingFrom:[OAApplicationMode PEDESTRIAN]])
    {
        if (mc == KILOMETERS_AND_METERS)
            return @(MINUTES_PER_KILOMETER);
        else
            return @(MILES_PER_HOUR);
    }
    if ([mode isDerivedRoutingFrom:[OAApplicationMode BOAT]])
        return @(NAUTICALMILES_PER_HOUR);
    
    if (mc == NAUTICAL_MILES)
        return @(NAUTICALMILES_PER_HOUR);
    else if (mc == KILOMETERS_AND_METERS)
        return @(KILOMETERS_PER_HOUR);
    else
        return @(MILES_PER_HOUR);
}

- (void) resetToDefault
{
    EOASpeedConstant defaultValue = self.defValue;
    NSObject *pDefault = [self getProfileDefaultValue:self.appMode];
    if (pDefault)
        defaultValue = (EOASpeedConstant)((NSNumber *)pDefault).intValue;
    
    [self set:defaultValue];
}

@end

@interface OAProfileMapMarkersMode ()

@property (nonatomic) EOAMapMarkersMode defValue;

@end

@implementation OAProfileMapMarkersMode

@dynamic defValue;

+ (instancetype) withKey:(NSString *)key defValue:(EOAMapMarkersMode)defValue
{
    return [super withKey:key defValue:defValue];
}

- (EOAMapMarkersMode) get
{
    return [super get];
}

- (void) set:(EOAMapMarkersMode)mapMarkersMode
{
    [super set:mapMarkersMode];
}

- (EOAMapMarkersMode) get:(OAApplicationMode *)mode
{
    return [super get:mode];
}

- (void) set:(EOAMapMarkersMode)mapMarkersMode mode:(OAApplicationMode *)mode
{
    [super set:mapMarkersMode mode:mode];
}

- (void) resetToDefault
{
    EOAMapMarkersMode defaultValue = self.defValue;
    NSObject *pDefault = [self getProfileDefaultValue:self.appMode];
    if (pDefault)
        defaultValue = (EOAMapMarkersMode)((NSNumber *)pDefault).intValue;
    
    [self set:defaultValue];
}

@end

@implementation OAAppSettings
{
    NSMapTable<NSString *, OAProfileBoolean *> *_customBooleanRoutingProps;
    NSMapTable<NSString *, OAProfileString *> *_customRoutingProps;
}

@synthesize settingShowMapRulet=_settingShowMapRulet, settingMapLanguage=_settingMapLanguage, settingAppMode=_settingAppMode;
@synthesize mapSettingShowFavorites=_mapSettingShowFavorites, settingPrefMapLanguage=_settingPrefMapLanguage;
@synthesize settingMapLanguageShowLocal=_settingMapLanguageShowLocal, settingMapLanguageTranslit=_settingMapLanguageTranslit;

+ (OAAppSettings*)sharedManager
{
    static OAAppSettings *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[OAAppSettings alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _customBooleanRoutingProps = [NSMapTable strongToStrongObjectsMapTable];
        
        _trackIntervalArray = @[@0, @1, @2, @3, @5, @10, @15, @30, @60, @90, @120, @180, @300];
        
        _mapLanguages = @[@"af", @"ar", @"az", @"be", @"bg", @"bn", @"br", @"bs", @"ca", @"ceb", @"cs", @"cy", @"da", @"de", @"el", @"eo", @"es", @"et", @"eu", @"id", @"fa", @"fi", @"fr", @"fy", @"ga", @"gl", @"he", @"hi", @"hr", @"ht", @"hu", @"hy", @"is", @"it", @"ja", @"ka", @"kn", @"ko", @"ku", @"la", @"lb", @"lt", @"lv", @"mk", @"ml", @"mr", @"ms", @"nds", @"new", @"nl", @"nn", @"no", @"nv", @"os", @"pl", @"pt", @"ro", @"ru", @"sc", @"sh", @"sk", @"sl", @"sq", @"sr", @"sv", @"sw", @"ta", @"te", @"th", @"tl", @"tr", @"uk", @"vi", @"vo", @"zh"];
        
        _ttsAvailableVoices = @[@"de", @"en", @"es", @"fr", @"it", @"ja", @"nl", @"pl", @"pt", @"ru", @"zh"];

        // Common Settings
        _settingMapLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:settingMapLanguageKey] ? (int)[[NSUserDefaults standardUserDefaults] integerForKey:settingMapLanguageKey] : 0;
        
        _settingPrefMapLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:settingPrefMapLanguageKey];
        _settingMapLanguageShowLocal = [[NSUserDefaults standardUserDefaults] objectForKey:settingMapLanguageShowLocalKey] ? [[NSUserDefaults standardUserDefaults] boolForKey:settingMapLanguageShowLocalKey] : NO;
        _settingMapLanguageTranslit = [[NSUserDefaults standardUserDefaults] objectForKey:settingMapLanguageTranslitKey] ? [[NSUserDefaults standardUserDefaults] boolForKey:settingMapLanguageTranslitKey] : NO;

        _settingShowMapRulet = [[NSUserDefaults standardUserDefaults] objectForKey:settingShowMapRuletKey] ? [[NSUserDefaults standardUserDefaults] boolForKey:settingShowMapRuletKey] : YES;
        _settingAppMode = [[NSUserDefaults standardUserDefaults] objectForKey:settingAppModeKey] ? (int)[[NSUserDefaults standardUserDefaults] integerForKey:settingAppModeKey] : 0;

        _drivingRegion = [[NSUserDefaults standardUserDefaults] objectForKey:drivingRegionKey] ? [[NSUserDefaults standardUserDefaults] integerForKey:drivingRegionKey] : [OADrivingRegion getDefaultRegion];
        _metricSystem = [[NSUserDefaults standardUserDefaults] objectForKey:metricSystemKey] ? [[NSUserDefaults standardUserDefaults] integerForKey:metricSystemKey] : [OADrivingRegion getDefMetrics:_drivingRegion];
        
        _settingShowZoomButton = YES;//[[NSUserDefaults standardUserDefaults] objectForKey:settingZoomButtonKey] ? [[NSUserDefaults standardUserDefaults] boolForKey:settingZoomButtonKey] : YES;
        _settingGeoFormat = [[NSUserDefaults standardUserDefaults] objectForKey:settingGeoFormatKey] ? (int)[[NSUserDefaults standardUserDefaults] integerForKey:settingGeoFormatKey] : MAP_GEO_FORMAT_DEGREES;
        _settingMapArrows = [[NSUserDefaults standardUserDefaults] objectForKey:settingMapArrowsKey] ? (int)[[NSUserDefaults standardUserDefaults] integerForKey:settingMapArrowsKey] : MAP_ARROWS_LOCATION;
        
        _settingShowAltInDriveMode = [[NSUserDefaults standardUserDefaults] objectForKey:settingMapShowAltInDriveModeKey] ? [[NSUserDefaults standardUserDefaults] boolForKey:settingMapShowAltInDriveModeKey] : NO;

        _settingDoNotShowPromotions = [[NSUserDefaults standardUserDefaults] objectForKey:settingDoNotShowPromotionsKey] ? [[NSUserDefaults standardUserDefaults] boolForKey:settingDoNotShowPromotionsKey] : NO;
        _settingDoNotUseFirebase = [[NSUserDefaults standardUserDefaults] objectForKey:settingDoNotUseFirebaseKey] ? [[NSUserDefaults standardUserDefaults] boolForKey:settingDoNotUseFirebaseKey] : NO;

        // Map Settings
        _mapSettingShowFavorites = [[NSUserDefaults standardUserDefaults] objectForKey:mapSettingShowFavoritesKey] ? [[NSUserDefaults standardUserDefaults] boolForKey:mapSettingShowFavoritesKey] : NO;
        _mapSettingVisibleGpx = [[NSUserDefaults standardUserDefaults] objectForKey:mapSettingVisibleGpxKey] ? [[NSUserDefaults standardUserDefaults] objectForKey:mapSettingVisibleGpxKey] : @[];

        _mapSettingTrackRecording = [[NSUserDefaults standardUserDefaults] objectForKey:mapSettingTrackRecordingKey] ? [[NSUserDefaults standardUserDefaults] boolForKey:mapSettingTrackRecordingKey] : NO;
        _mapSettingSaveTrackInterval = [[NSUserDefaults standardUserDefaults] objectForKey:mapSettingSaveTrackIntervalKey] ? (int)[[NSUserDefaults standardUserDefaults] integerForKey:mapSettingSaveTrackIntervalKey] : SAVE_TRACK_INTERVAL_DEFAULT;
        _mapSettingSaveTrackIntervalGlobal = [[NSUserDefaults standardUserDefaults] objectForKey:mapSettingSaveTrackIntervalGlobalKey] ? (int)[[NSUserDefaults standardUserDefaults] integerForKey:mapSettingSaveTrackIntervalGlobalKey] : SAVE_TRACK_INTERVAL_DEFAULT;

        _mapSettingShowRecordingTrack = [[NSUserDefaults standardUserDefaults] objectForKey:mapSettingShowRecordingTrackKey] ? [[NSUserDefaults standardUserDefaults] boolForKey:mapSettingShowRecordingTrackKey] : NO;
        _mapSettingSaveTrackIntervalApproved = [[NSUserDefaults standardUserDefaults] objectForKey:mapSettingSaveTrackIntervalApprovedKey] ? [[NSUserDefaults standardUserDefaults] boolForKey:mapSettingSaveTrackIntervalApprovedKey] : NO;
        _mapSettingActiveRouteFileName = [[NSUserDefaults standardUserDefaults] objectForKey:mapSettingActiveRouteFileNameKey];
        _mapSettingActiveRouteVariantType = [[NSUserDefaults standardUserDefaults] objectForKey:mapSettingActiveRouteVariantTypeKey] ? (int)[[NSUserDefaults standardUserDefaults] integerForKey:mapSettingActiveRouteVariantTypeKey] : 0;

        _selectedPoiFilters = [[NSUserDefaults standardUserDefaults] objectForKey:selectedPoiFiltersKey] ? [[NSUserDefaults standardUserDefaults] objectForKey:selectedPoiFiltersKey] : @[];

        _plugins = [[NSUserDefaults standardUserDefaults] objectForKey:pluginsKey] ? [NSSet setWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:pluginsKey]] : [NSSet set];

        _discountId = [[NSUserDefaults standardUserDefaults] objectForKey:discountIdKey] ? [[NSUserDefaults standardUserDefaults] integerForKey:discountIdKey] : 0;
        _discountShowNumberOfStarts = [[NSUserDefaults standardUserDefaults] objectForKey:discountShowNumberOfStartsKey] ? [[NSUserDefaults standardUserDefaults] integerForKey:discountShowNumberOfStartsKey] : 0;
        _discountTotalShow = [[NSUserDefaults standardUserDefaults] objectForKey:discountTotalShowKey] ? [[NSUserDefaults standardUserDefaults] integerForKey:discountTotalShowKey] : 0;
        _discountShowDatetime = [[NSUserDefaults standardUserDefaults] objectForKey:discountShowDatetimeKey] ? [[NSUserDefaults standardUserDefaults] doubleForKey:discountShowDatetimeKey] : 0;
        
        _lastSearchedCity = [[NSUserDefaults standardUserDefaults] objectForKey:lastSearchedCityKey] ? ((NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:lastSearchedCityKey]).unsignedLongLongValue : 0;
        _lastSearchedCityName = [[NSUserDefaults standardUserDefaults] objectForKey:lastSearchedCityNameKey];
        
        double lastSearchedPointLat = [[NSUserDefaults standardUserDefaults] objectForKey:lastSearchedPointLatKey] ? [[NSUserDefaults standardUserDefaults] doubleForKey:lastSearchedPointLatKey] : 0.0;
        double lastSearchedPointLon = [[NSUserDefaults standardUserDefaults] objectForKey:lastSearchedPointLonKey] ? [[NSUserDefaults standardUserDefaults] doubleForKey:lastSearchedPointLonKey] : 0.0;
        if (lastSearchedPointLat != 0.0 && lastSearchedPointLon != 0.0)
        {
            _lastSearchedPoint = [[CLLocation alloc] initWithLatitude:lastSearchedPointLat longitude:lastSearchedPointLon];
        }
        
        _applicationMode = [OAApplicationMode valueOfStringKey:[[NSUserDefaults standardUserDefaults] objectForKey:applicationModeKey] def:[OAApplicationMode DEFAULT]];

        _defaultApplicationMode = [OAApplicationMode valueOfStringKey:[[NSUserDefaults standardUserDefaults] objectForKey:defaultApplicationModeKey] def:[OAApplicationMode DEFAULT]];

        _availableApplicationModes = [[NSUserDefaults standardUserDefaults] objectForKey:availableApplicationModesKey];
        if (!_availableApplicationModes)
            self.availableApplicationModes = @"car,bicycle,pedestrian,";

        _mapInfoControls = [OAProfileString withKey:mapInfoControlsKey defValue:@""];
        
        _showDestinationArrow = [OAProfileBoolean withKey:showDestinationArrowKey defValue:NO];
        [_showDestinationArrow setModeDefaultValue:@YES mode:[OAApplicationMode PEDESTRIAN]];

        _transparentMapTheme = [OAProfileBoolean withKey:showDestinationArrowKey defValue:YES];
        [_transparentMapTheme setModeDefaultValue:@NO mode:[OAApplicationMode CAR]];
        [_transparentMapTheme setModeDefaultValue:@NO mode:[OAApplicationMode BICYCLE]];
        [_transparentMapTheme setModeDefaultValue:@YES mode:[OAApplicationMode PEDESTRIAN]];

        _showStreetName = [OAProfileBoolean withKey:showStreetNameKey defValue:NO];
        [_showStreetName setModeDefaultValue:@NO mode:[OAApplicationMode DEFAULT]];
        [_showStreetName setModeDefaultValue:@YES mode:[OAApplicationMode CAR]];
        [_showStreetName setModeDefaultValue:@NO mode:[OAApplicationMode BICYCLE]];
        [_showStreetName setModeDefaultValue:@NO mode:[OAApplicationMode PEDESTRIAN]];
        
        _showArrivalTime = [OAProfileBoolean withKey:showArrivalTimeKey defValue:YES];
        
        _centerPositionOnMap = [OAProfileBoolean withKey:centerPositionOnMapKey defValue:NO];

        _mapMarkersMode = [OAProfileMapMarkersMode withKey:mapMarkersModeKey defValue:MAP_MARKERS_MODE_TOOLBAR];
        [_mapMarkersMode setModeDefaultValue:@(MAP_MARKERS_MODE_TOOLBAR) mode:[OAApplicationMode DEFAULT]];
        [_mapMarkersMode setModeDefaultValue:@(MAP_MARKERS_MODE_TOOLBAR) mode:[OAApplicationMode CAR]];
        [_mapMarkersMode setModeDefaultValue:@(MAP_MARKERS_MODE_TOOLBAR) mode:[OAApplicationMode BICYCLE]];
        [_mapMarkersMode setModeDefaultValue:@(MAP_MARKERS_MODE_TOOLBAR) mode:[OAApplicationMode PEDESTRIAN]];

        // navigation settings
        _useFastRecalculation = [[NSUserDefaults standardUserDefaults] objectForKey:useFastRecalculationKey] ? [[NSUserDefaults standardUserDefaults] boolForKey:useFastRecalculationKey] : YES;
        _fastRouteMode = [OAProfileBoolean withKey:fastRouteModeKey defValue:YES];
        _disableComplexRouting = [[NSUserDefaults standardUserDefaults] objectForKey:disableComplexRoutingKey] ? [[NSUserDefaults standardUserDefaults] boolForKey:disableComplexRoutingKey] : NO;
        _followTheRoute = [[NSUserDefaults standardUserDefaults] objectForKey:followTheRouteKey] ? [[NSUserDefaults standardUserDefaults] boolForKey:followTheRouteKey] : NO;
        _followTheGpxRoute = [[NSUserDefaults standardUserDefaults] objectForKey:followTheGpxRouteKey] ? [[NSUserDefaults standardUserDefaults] stringForKey:followTheGpxRouteKey] : nil;
        _arrivalDistanceFactor = [OAProfileDouble withKey:arrivalDistanceFactorKey defValue:1.0];
        _useIntermediatePointsNavigation = [[NSUserDefaults standardUserDefaults] objectForKey:useIntermediatePointsNavigationKey] ? [[NSUserDefaults standardUserDefaults] boolForKey:useIntermediatePointsNavigationKey] : NO;
        _disableOffrouteRecalc = [[NSUserDefaults standardUserDefaults] objectForKey:disableOffrouteRecalcKey] ? [[NSUserDefaults standardUserDefaults] boolForKey:disableOffrouteRecalcKey] : NO;
        _disableWrongDirectionRecalc = [[NSUserDefaults standardUserDefaults] objectForKey:disableWrongDirectionRecalcKey] ? [[NSUserDefaults standardUserDefaults] boolForKey:disableWrongDirectionRecalcKey] : NO;
        _routerService = [OAProfileInteger withKey:routerServiceKey defValue:0]; // OSMAND
        
        _autoFollowRoute = [OAProfileInteger withKey:autoFollowRouteKey defValue:0];
        [_autoFollowRoute setModeDefaultValue:@15 mode:[OAApplicationMode CAR]];
        [_autoFollowRoute setModeDefaultValue:@15 mode:[OAApplicationMode BICYCLE]];
        [_autoFollowRoute setModeDefaultValue:@0 mode:[OAApplicationMode PEDESTRIAN]];
        
        _autoZoomMap = [OAProfileBoolean withKey:autoZoomMapKey defValue:NO];
        [_autoZoomMap setModeDefaultValue:@YES mode:[OAApplicationMode CAR]];
        [_autoZoomMap setModeDefaultValue:@NO mode:[OAApplicationMode BICYCLE]];
        [_autoZoomMap setModeDefaultValue:@NO mode:[OAApplicationMode PEDESTRIAN]];

        _autoZoomMapScale = [OAProfileAutoZoomMap withKey:autoZoomMapScaleKey defValue:AUTO_ZOOM_MAP_FAR];
        [_autoZoomMapScale setModeDefaultValue:@(AUTO_ZOOM_MAP_FAR) mode:[OAApplicationMode CAR]];
        [_autoZoomMapScale setModeDefaultValue:@(AUTO_ZOOM_MAP_CLOSE) mode:[OAApplicationMode BICYCLE]];
        [_autoZoomMapScale setModeDefaultValue:@(AUTO_ZOOM_MAP_CLOSE) mode:[OAApplicationMode PEDESTRIAN]];

        _keepInforming = [OAProfileInteger withKey:keepInformingKey defValue:0];
        [_keepInforming setModeDefaultValue:@0 mode:[OAApplicationMode CAR]];
        [_keepInforming setModeDefaultValue:@0 mode:[OAApplicationMode BICYCLE]];
        [_keepInforming setModeDefaultValue:@0 mode:[OAApplicationMode PEDESTRIAN]];

        _speedSystem = [OAProfileSpeedConstant withKey:speedSystemKey defValue:KILOMETERS_PER_HOUR];
        _speedLimitExceed = [OAProfileDouble withKey:speedLimitExceedKey defValue:5.f];
        _switchMapDirectionToCompass = [OAProfileDouble withKey:switchMapDirectionToCompassKey defValue:0.f];

        _wakeOnVoiceInt = [OAProfileInteger withKey:wakeOnVoiceIntKey defValue:0];
        [_wakeOnVoiceInt setModeDefaultValue:@0 mode:[OAApplicationMode CAR]];
        [_wakeOnVoiceInt setModeDefaultValue:@0 mode:[OAApplicationMode BICYCLE]];
        [_wakeOnVoiceInt setModeDefaultValue:@0 mode:[OAApplicationMode PEDESTRIAN]];

        _showTrafficWarnings = [OAProfileBoolean withKey:showTrafficWarningsKey defValue:NO];
        [_showTrafficWarnings setModeDefaultValue:@YES mode:[OAApplicationMode CAR]];
        
        _showPedestrian = [OAProfileBoolean withKey:showPedestrianKey defValue:NO];
        [_showPedestrian setModeDefaultValue:@YES mode:[OAApplicationMode CAR]];

        _showCameras = [OAProfileBoolean withKey:showCamerasKey defValue:NO];
        
        _showLanes = [OAProfileBoolean withKey:showLanesKey defValue:NO];
        [_showLanes setModeDefaultValue:@YES mode:[OAApplicationMode CAR]];
        [_showLanes setModeDefaultValue:@YES mode:[OAApplicationMode BICYCLE]];
        
        _speakStreetNames = [OAProfileBoolean withKey:speakStreetNamesKey defValue:YES];
        _speakTrafficWarnings = [OAProfileBoolean withKey:speakTrafficWarningsKey defValue:YES];
        _speakPedestrian = [OAProfileBoolean withKey:speakPedestrianKey defValue:YES];
        _speakSpeedLimit = [OAProfileBoolean withKey:speakSpeedLimitKey defValue:YES];
        _speakCameras = [OAProfileBoolean withKey:speakCamerasKey defValue:NO];
        _announceWpt = [OAProfileBoolean withKey:announceWptKey defValue:YES];
        _announceNearbyFavorites = [OAProfileBoolean withKey:announceNearbyFavoritesKey defValue:NO];
        _announceNearbyPoi = [OAProfileBoolean withKey:announceNearbyPoiKey defValue:NO];

        _showGpxWpt = [[NSUserDefaults standardUserDefaults] objectForKey:showGpxWptKey] ? [[NSUserDefaults standardUserDefaults] boolForKey:showGpxWptKey] : YES;
        
        _showNearbyFavorites = [OAProfileBoolean withKey:showNearbyFavoritesKey defValue:NO];
        _showNearbyPoi = [OAProfileBoolean withKey:showNearbyPoiKey defValue:NO];
        
        _gpxRouteCalcOsmandParts = [[NSUserDefaults standardUserDefaults] objectForKey:gpxRouteCalcOsmandPartsKey] ? [[NSUserDefaults standardUserDefaults] boolForKey:gpxRouteCalcOsmandPartsKey] : YES;
        _gpxCalculateRtept = [[NSUserDefaults standardUserDefaults] objectForKey:gpxCalculateRteptKey] ? [[NSUserDefaults standardUserDefaults] boolForKey:gpxCalculateRteptKey] : YES;
        _gpxRouteCalc = [[NSUserDefaults standardUserDefaults] objectForKey:gpxRouteCalcKey] ? [[NSUserDefaults standardUserDefaults] boolForKey:gpxRouteCalcKey] : NO;

        _voiceMute = [[NSUserDefaults standardUserDefaults] objectForKey:voiceMuteKey] ? [[NSUserDefaults standardUserDefaults] boolForKey:voiceMuteKey] : NO;
        _voiceProvider = [[NSUserDefaults standardUserDefaults] objectForKey:voiceProviderKey] ? [[NSUserDefaults standardUserDefaults] stringForKey:voiceProviderKey] : nil;
        _interruptMusic = [OAProfileBoolean withKey:interruptMusicKey defValue:NO];
        _snapToRoad = [OAProfileBoolean withKey:snapToRoadKey defValue:NO];
        [_snapToRoad setModeDefaultValue:@YES mode:[OAApplicationMode CAR]];
        [_snapToRoad setModeDefaultValue:@YES mode:[OAApplicationMode BICYCLE]];
    }
    return self;
}

// Common Settings
- (void) setSettingShowMapRulet:(BOOL)settingShowMapRulet {
    _settingShowMapRulet = settingShowMapRulet;
    [[NSUserDefaults standardUserDefaults] setBool:_settingShowMapRulet forKey:settingShowMapRuletKey];
}

- (void) setSettingMapLanguage:(int)settingMapLanguage {
    _settingMapLanguage = settingMapLanguage;
    [[NSUserDefaults standardUserDefaults] setInteger:_settingMapLanguage forKey:settingMapLanguageKey];
    [[[OsmAndApp instance] mapSettingsChangeObservable] notifyEvent];
}

- (void) setSettingPrefMapLanguage:(NSString *)settingPrefMapLanguage
{
    _settingPrefMapLanguage = settingPrefMapLanguage;
    [[NSUserDefaults standardUserDefaults] setObject:_settingPrefMapLanguage forKey:settingPrefMapLanguageKey];
    [[[OsmAndApp instance] mapSettingsChangeObservable] notifyEvent];
}

- (void) setSettingMapLanguageShowLocal:(BOOL)settingMapLanguageShowLocal
{
    _settingMapLanguageShowLocal = settingMapLanguageShowLocal;
    [[NSUserDefaults standardUserDefaults] setBool:_settingMapLanguageShowLocal forKey:settingMapLanguageShowLocalKey];
}

- (void) setSettingMapLanguageTranslit:(BOOL)settingMapLanguageTranslit
{
    _settingMapLanguageTranslit = settingMapLanguageTranslit;
    [[NSUserDefaults standardUserDefaults] setBool:_settingMapLanguageTranslit forKey:settingMapLanguageTranslitKey];
}

- (void) setSettingAppMode:(int)settingAppMode
{
    _settingAppMode = settingAppMode;
    [[NSUserDefaults standardUserDefaults] setInteger:_settingAppMode forKey:settingAppModeKey];
    [[[OsmAndApp instance] dayNightModeObservable] notifyEvent];
}

- (void) setMetricSystem:(EOAMetricsConstant)metricSystem
{
    _metricSystem = metricSystem;
    [[NSUserDefaults standardUserDefaults] setInteger:_metricSystem forKey:metricSystemKey];
}

- (void) setDrivingRegion:(EOADrivingRegion)drivingRegion
{
    _drivingRegion = drivingRegion;
    [[NSUserDefaults standardUserDefaults] setInteger:_drivingRegion forKey:drivingRegionKey];
}

- (void) setSettingShowZoomButton:(BOOL)settingShowZoomButton
{
    _settingShowZoomButton = settingShowZoomButton;
    [[NSUserDefaults standardUserDefaults] setInteger:_settingShowZoomButton forKey:settingZoomButtonKey];
}

- (void) setSettingGeoFormat:(int)settingGeoFormat
{
    _settingGeoFormat = settingGeoFormat;
    [[NSUserDefaults standardUserDefaults] setInteger:_settingGeoFormat forKey:settingGeoFormatKey];
}

- (void) setSettingMapArrows:(int)settingMapArrows
{
    _settingMapArrows = settingMapArrows;
    [[NSUserDefaults standardUserDefaults] setInteger:_settingMapArrows forKey:settingMapArrowsKey];
}

- (void) setSettingShowAltInDriveMode:(BOOL)settingShowAltInDriveMode
{
    _settingShowAltInDriveMode = settingShowAltInDriveMode;
    [[NSUserDefaults standardUserDefaults] setBool:_settingShowAltInDriveMode forKey:settingMapShowAltInDriveModeKey];
}

- (void) setSettingDoNotShowPromotions:(BOOL)settingDoNotShowPromotions
{
    _settingDoNotShowPromotions = settingDoNotShowPromotions;
    [[NSUserDefaults standardUserDefaults] setBool:_settingDoNotShowPromotions forKey:settingDoNotShowPromotionsKey];
}

- (void) setSettingDoNotUseFirebase:(BOOL)settingDoNotUseFirebase
{
    _settingDoNotUseFirebase = settingDoNotUseFirebase;
    [[NSUserDefaults standardUserDefaults] setBool:_settingDoNotUseFirebase forKey:settingDoNotUseFirebaseKey];
}

// Map Settings
- (void) setMapSettingShowFavorites:(BOOL)mapSettingShowFavorites
{
    //if (_mapSettingShowFavorites == mapSettingShowFavorites)
    //    return;
    
    _mapSettingShowFavorites = mapSettingShowFavorites;
    [[NSUserDefaults standardUserDefaults] setBool:_mapSettingShowFavorites forKey:mapSettingShowFavoritesKey];

    OsmAndAppInstance app = [OsmAndApp instance];
    if (_mapSettingShowFavorites)
    {
        if (![app.data.mapLayersConfiguration isLayerVisible:kFavoritesLayerId])
        {
            [app.data.mapLayersConfiguration setLayer:kFavoritesLayerId
                                           Visibility:YES];
        }
    }
    else
    {
        if ([app.data.mapLayersConfiguration isLayerVisible:kFavoritesLayerId])
        {
            [app.data.mapLayersConfiguration setLayer:kFavoritesLayerId
                                           Visibility:NO];
        }
    }
}

- (void) setMapSettingTrackRecording:(BOOL)mapSettingTrackRecording
{
    _mapSettingTrackRecording = mapSettingTrackRecording;
    [[NSUserDefaults standardUserDefaults] setBool:_mapSettingTrackRecording forKey:mapSettingTrackRecordingKey];
    [[[OsmAndApp instance] trackStartStopRecObservable] notifyEvent];
}

- (void) setMapSettingSaveTrackInterval:(int)mapSettingSaveTrackInterval
{
    _mapSettingSaveTrackInterval = mapSettingSaveTrackInterval;
    [[NSUserDefaults standardUserDefaults] setInteger:_mapSettingSaveTrackInterval forKey:mapSettingSaveTrackIntervalKey];
}

- (void) setMapSettingSaveTrackIntervalGlobal:(int)mapSettingSaveTrackIntervalGlobal
{
    _mapSettingSaveTrackIntervalGlobal = mapSettingSaveTrackIntervalGlobal;
    [[NSUserDefaults standardUserDefaults] setInteger:_mapSettingSaveTrackIntervalGlobal forKey:mapSettingSaveTrackIntervalGlobalKey];
    [self setMapSettingSaveTrackInterval:_mapSettingSaveTrackIntervalGlobal];
}

- (void) setMapSettingVisibleGpx:(NSArray *)mapSettingVisibleGpx
{
    _mapSettingVisibleGpx = mapSettingVisibleGpx;
    [[NSUserDefaults standardUserDefaults] setObject:_mapSettingVisibleGpx forKey:mapSettingVisibleGpxKey];
}

- (void) setSelectedPoiFilters:(NSArray<NSString *> *)selectedPoiFilters
{
    _selectedPoiFilters = selectedPoiFilters;
    [[NSUserDefaults standardUserDefaults] setObject:_selectedPoiFilters forKey:selectedPoiFiltersKey];
}

- (void) setPlugins:(NSSet<NSString *> *)plugins
{
    _plugins = plugins;
    [[NSUserDefaults standardUserDefaults] setObject:[_plugins allObjects] forKey:pluginsKey];
}

- (NSSet<NSString *> *) getEnabledPlugins
{
    NSMutableSet<NSString *> *res = [NSMutableSet set];
    for (NSString *p in _plugins)
    {
        if (![p hasPrefix:@"-"])
            [res addObject:p];
    }
    return [NSSet setWithSet:res];
}

- (NSSet<NSString *> *) getPlugins
{
    return _plugins;
}

- (void) enablePlugin:(NSString *)pluginId enable:(BOOL)enable
{
    NSMutableSet<NSString*> *set = [NSMutableSet setWithSet:[self getPlugins]];
    if (enable)
    {
        [set removeObject:[@"-"  stringByAppendingString:pluginId]];
        [set addObject:pluginId];
    }
    else
    {
        [set removeObject:pluginId];
        [set addObject:[@"-" stringByAppendingString:pluginId]];
    }
    if (![set isEqualToSet:_plugins])
        [self setPlugins:set];
}

- (void) setMapSettingShowRecordingTrack:(BOOL)mapSettingShowRecordingTrack
{
    _mapSettingShowRecordingTrack = mapSettingShowRecordingTrack;
    [[NSUserDefaults standardUserDefaults] setBool:_mapSettingShowRecordingTrack forKey:mapSettingShowRecordingTrackKey];
}

- (void) setMapSettingSaveTrackIntervalApproved:(BOOL)mapSettingSaveTrackIntervalApproved
{
    _mapSettingSaveTrackIntervalApproved = mapSettingSaveTrackIntervalApproved;
    [[NSUserDefaults standardUserDefaults] setBool:_mapSettingSaveTrackIntervalApproved forKey:mapSettingSaveTrackIntervalApprovedKey];
}

- (void) setMapSettingActiveRouteFileName:(NSString *)mapSettingActiveRouteFileName
{
    _mapSettingActiveRouteFileName = mapSettingActiveRouteFileName;
    [[NSUserDefaults standardUserDefaults] setObject:_mapSettingActiveRouteFileName forKey:mapSettingActiveRouteFileNameKey];
}

- (void) setMapSettingActiveRouteVariantType:(int)mapSettingActiveRouteVariantType
{
    _mapSettingActiveRouteVariantType = mapSettingActiveRouteVariantType;
    [[NSUserDefaults standardUserDefaults] setInteger:_mapSettingActiveRouteVariantType forKey:mapSettingActiveRouteVariantTypeKey];
}

- (void) setDiscountId:(NSInteger)discountId
{
    _discountId = discountId;
    [[NSUserDefaults standardUserDefaults] setInteger:discountId forKey:discountIdKey];
}

- (void) setDiscountShowNumberOfStarts:(NSInteger)discountShowNumberOfStarts
{
    _discountShowNumberOfStarts = discountShowNumberOfStarts;
    [[NSUserDefaults standardUserDefaults] setInteger:discountShowNumberOfStarts forKey:discountShowNumberOfStartsKey];
}

- (void) setDiscountTotalShow:(NSInteger)discountTotalShow
{
    _discountTotalShow = discountTotalShow;
    [[NSUserDefaults standardUserDefaults] setInteger:discountTotalShow forKey:discountTotalShowKey];
}

- (void) setDiscountShowDatetime:(double)discountShowDatetime
{
    _discountShowDatetime = discountShowDatetime;
    [[NSUserDefaults standardUserDefaults] setInteger:discountShowDatetime forKey:discountShowDatetimeKey];
}

- (void)  setLastSearchedCity:(unsigned long long)lastSearchedCity
{
    _lastSearchedCity = lastSearchedCity;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedLongLong:lastSearchedCity] forKey:lastSearchedCityKey];
}

- (void)  setLastSearchedCityName:(NSString *)lastSearchedCityName
{
    _lastSearchedCityName = lastSearchedCityName;
    [[NSUserDefaults standardUserDefaults] setObject:lastSearchedCityName forKey:lastSearchedCityNameKey];
}

- (void)  setLastSearchedPoint:(CLLocation *)lastSearchedPoint
{
    _lastSearchedPoint = lastSearchedPoint;
    if (lastSearchedPoint)
    {
        [[NSUserDefaults standardUserDefaults] setDouble:lastSearchedPoint.coordinate.latitude forKey:lastSearchedPointLatKey];
        [[NSUserDefaults standardUserDefaults] setDouble:lastSearchedPoint.coordinate.longitude forKey:lastSearchedPointLonKey];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:lastSearchedPointLatKey];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:lastSearchedPointLonKey];
    }
}

- (void) setApplicationMode:(OAApplicationMode *)applicationMode
{
    OAApplicationMode *prevAppMode = _applicationMode;
    _applicationMode = applicationMode;
    [[NSUserDefaults standardUserDefaults] setObject:applicationMode.stringKey forKey:applicationModeKey];
    [[[OsmAndApp instance].data applicationModeChangedObservable] notifyEventWithKey:prevAppMode];
}

- (void) setDefaultApplicationMode:(OAApplicationMode *)defaultApplicationMode
{
    _defaultApplicationMode = defaultApplicationMode;
    [[NSUserDefaults standardUserDefaults] setObject:defaultApplicationMode.stringKey forKey:defaultApplicationModeKey];
}

- (void) setAvailableApplicationModes:(NSString *)availableApplicationModes
{
    _availableApplicationModes = availableApplicationModes;
    [[NSUserDefaults standardUserDefaults] setObject:availableApplicationModes forKey:availableApplicationModesKey];
    [[[OsmAndApp instance] availableAppModesChangedObservable] notifyEvent];
}

- (void) showGpx:(NSArray<NSString *> *)fileNames
{
    BOOL added = NO;
    for (NSString *fileName in fileNames)
    {
        if (![_mapSettingVisibleGpx containsObject:fileName])
        {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:_mapSettingVisibleGpx];
            [arr addObject:fileName];
            self.mapSettingVisibleGpx = arr;
            added = YES;
        }
    }
    if (added)
    {
        [[[OsmAndApp instance] updateGpxTracksOnMapObservable] notifyEvent];
    }
}

- (void) updateGpx:(NSArray<NSString *> *)fileNames
{
    BOOL added = NO;
    BOOL removed = NO;
    for (NSString *fileName in fileNames)
    {
        if (![_mapSettingVisibleGpx containsObject:fileName])
        {
            added = YES;
            break;
        }
    }
    for (NSString *visible in _mapSettingVisibleGpx)
    {
        if (![fileNames containsObject:visible])
        {
            removed = YES;
            break;
        }
    }

    if (added || removed)
    {
        self.mapSettingVisibleGpx = [NSMutableArray arrayWithArray:fileNames];
        [[[OsmAndApp instance] updateGpxTracksOnMapObservable] notifyEvent];
    }
}

- (void) hideGpx:(NSArray<NSString *> *)fileNames
{
    BOOL removed = NO;
    for (NSString *fileName in fileNames)
    {
        if ([_mapSettingVisibleGpx containsObject:fileName])
        {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:_mapSettingVisibleGpx];
            [arr removeObject:fileName];
            self.mapSettingVisibleGpx = arr;
            removed = YES;
        }
    }
    if (removed)
        [[[OsmAndApp instance] updateGpxTracksOnMapObservable] notifyEvent];
}

- (void) hideRemovedGpx
{
    OsmAndAppInstance app = [OsmAndApp instance];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:_mapSettingVisibleGpx];
    self.mapSettingVisibleGpx = arr;
    for (NSString *fileName in _mapSettingVisibleGpx)
    {
        NSString *path = [app.gpxPath stringByAppendingPathComponent:fileName];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            [arr removeObject:fileName];
        }
    }
    self.mapSettingVisibleGpx = arr;
}

- (NSString *) getFormattedTrackInterval:(int)value
{
    NSString *res;
    if (value == 0)
        res = OALocalizedString(@"rec_interval_minimum");
    else if (value > 90)
        res = [NSString stringWithFormat:@"%d %@", (int)(value / 60.0), OALocalizedString(@"units_minutes_short")];
    else
        res = [NSString stringWithFormat:@"%d %@", value, OALocalizedString(@"units_seconds_short")];
    return res;
}

- (NSString *) getModeKey:(NSString *)key mode:(OAApplicationMode *)mode
{
    return [NSString stringWithFormat:@"%@_%@", key, mode.stringKey];
}

- (OAProfileBoolean *) getCustomRoutingBooleanProperty:(NSString *)attrName defaultValue:(BOOL)defaultValue
{
    OAProfileBoolean *value = [_customBooleanRoutingProps objectForKey:attrName];
    if (!value)
    {
        value = [OAProfileBoolean withKey:[NSString stringWithFormat:@"prouting_%@", attrName] defValue:defaultValue];
        [_customBooleanRoutingProps setObject:value forKey:attrName];
    }
    return value;
}

- (OAProfileString *) getCustomRoutingProperty:(NSString *)attrName defaultValue:(NSString *)defaultValue
{
    OAProfileString *value = [_customRoutingProps objectForKey:attrName];
    if (!value)
    {
        value = [OAProfileString withKey:[NSString stringWithFormat:@"prouting_%@", attrName] defValue:defaultValue];
        [_customRoutingProps setObject:value forKey:attrName];
    }
    return value;
}


// navigation settings
- (void) setUseFastRecalculation:(BOOL)useFastRecalculation
{
    _useFastRecalculation = useFastRecalculation;
    [[NSUserDefaults standardUserDefaults] setBool:_useFastRecalculation forKey:useFastRecalculationKey];
}

- (void) setDisableComplexRouting:(BOOL)disableComplexRouting
{
    _disableComplexRouting = disableComplexRouting;
    [[NSUserDefaults standardUserDefaults] setBool:_disableComplexRouting forKey:disableComplexRoutingKey];
}

- (void) setFollowTheRoute:(BOOL)followTheRoute
{
    _followTheRoute = followTheRoute;
    [[NSUserDefaults standardUserDefaults] setBool:_followTheRoute forKey:followTheRouteKey];
}

- (void)setFollowTheGpxRoute:(NSString *)followTheGpxRoute
{
    _followTheGpxRoute = followTheGpxRoute;
    [[NSUserDefaults standardUserDefaults] setObject:_followTheGpxRoute forKey:followTheGpxRouteKey];
}

- (void) setUseIntermediatePointsNavigation:(BOOL)useIntermediatePointsNavigation
{
    _useIntermediatePointsNavigation = useIntermediatePointsNavigation;
    [[NSUserDefaults standardUserDefaults] setBool:_useIntermediatePointsNavigation forKey:useIntermediatePointsNavigationKey];
}

- (void) setDisableOffrouteRecalc:(BOOL)disableOffrouteRecalc
{
    _disableOffrouteRecalc = disableOffrouteRecalc;
    [[NSUserDefaults standardUserDefaults] setBool:_disableOffrouteRecalc forKey:disableOffrouteRecalcKey];
}

- (void) setDisableWrongDirectionRecalc:(BOOL)disableWrongDirectionRecalc
{
    _disableWrongDirectionRecalc = disableWrongDirectionRecalc;
    [[NSUserDefaults standardUserDefaults] setBool:_disableWrongDirectionRecalc forKey:disableWrongDirectionRecalcKey];
}

- (void) setGpxRouteCalcOsmandParts:(BOOL)gpxRouteCalcOsmandParts
{
    _gpxRouteCalcOsmandParts = gpxRouteCalcOsmandParts;
    [[NSUserDefaults standardUserDefaults] setBool:_gpxRouteCalcOsmandParts forKey:gpxRouteCalcOsmandPartsKey];
}

- (void) setShowGpxWpt:(BOOL)showGpxWpt
{
    _showGpxWpt = showGpxWpt;
    [[NSUserDefaults standardUserDefaults] setBool:_showGpxWpt forKey:showGpxWptKey];
}

- (void) setGpxCalculateRtept:(BOOL)gpxCalculateRtept
{
    _gpxCalculateRtept = gpxCalculateRtept;
    [[NSUserDefaults standardUserDefaults] setBool:_gpxCalculateRtept forKey:gpxCalculateRteptKey];
}

- (void) setGpxRouteCalc:(BOOL)gpxRouteCalc
{
    _gpxRouteCalc = gpxRouteCalc;
    [[NSUserDefaults standardUserDefaults] setBool:_gpxRouteCalc forKey:gpxRouteCalcKey];
}

- (void) setVoiceMute:(BOOL)voiceMute
{
    _voiceMute = voiceMute;
    [[NSUserDefaults standardUserDefaults] setBool:_voiceMute forKey:voiceMuteKey];
}

- (void) setVoiceProvider:(NSString *)voiceProvider
{
    _voiceProvider = voiceProvider;
    [[NSUserDefaults standardUserDefaults] setObject:_voiceProvider forKey:voiceProviderKey];
}

- (NSString *) getDefaultVoiceProvider
{
    NSString *currentLang = [OAUtilities currentLang];
    for (NSString *lang in _ttsAvailableVoices)
    {
        if ([lang isEqualToString:currentLang])
        {
            return [lang stringByAppendingString:@"-tts"];
        }
    }
    return @"en-tts";
}

@end
