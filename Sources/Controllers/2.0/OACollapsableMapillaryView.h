//
//  OACollapsableMapillaryView.h
//  OsmAnd
//
//  Created by Paul on 24/05/2019.
//  Copyright © 2018 OsmAnd. All rights reserved.
//

#import "OACollapsableView.h"

#define TYPE_MAPILLARY_PHOTO @"mapillary-photo"
#define TYPE_MAPILLARY_CONTRIBUTE @"mapillary-contribute"
#define TYPE_MAPILLARY_EMPTY @"mapillary-empty"

@interface OACollapsableMapillaryView : OACollapsableView

- (void) setImages:(NSArray *)mapillaryImages;

@end
