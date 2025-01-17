//
//  OAMapSettingsMapillaryScreen.m
//  OsmAnd
//
//  Created by Paul on 31/05/19.
//  Copyright © 2018 OsmAnd. All rights reserved.
//

#import "OAMapSettingsMapillaryScreen.h"
#import "OAMapSettingsViewController.h"
#import "OASearchUICore.h"
#import "OAQuickSearchHelper.h"
#import "OAQuickSearchListItem.h"
#import "Localization.h"
#import "OACustomSearchPoiFilter.h"
#import "OAUtilities.h"
#import "OAIconTextDescCell.h"
#import "OAIconTextTableViewCell.h"
#import "OAQuickSearchButtonListItem.h"
#import "OAIconButtonCell.h"
#import "OAPOIUIFilter.h"
#import "OAPOIFiltersHelper.h"
#import "OAMapViewController.h"
#import "OARootViewController.h"
#import "OAIconTitleButtonCell.h"
#import "OASettingSwitchCell.h"
#import "OAIconTitleValueCell.h"
#import "OATimeTableViewCell.h"
#import "OADateTimePickerTableViewCell.h"
#import "OAColors.h"
#import "OAMapLayers.h"
#import "OAMapillaryLayer.h"
#import "OADividerCell.h"
#import "OAUsernameFilterViewController.h"

#define resetButtonTag 500
#define applyButtonTag 600

static const NSInteger visibilitySection = 0;
static const NSInteger nameFilterSection = 1;
static const NSInteger dateFilterSection = 2;
static const NSInteger panoImageFilterSection = 3;

@interface OAMapSettingsMapillaryScreen () <OAMapillaryScreenDelegate>

@end

@implementation OAMapSettingsMapillaryScreen
{
    OsmAndAppInstance _app;
    OAAppSettings *_settings;
    
    NSArray *_data;
    
    NSIndexPath *_datePickerIndexPath;
    double _startDate;
    double _endDate;
    
    NSString *_userNames;
    NSString *_userKeys;
    
    BOOL _mapillaryEnabled;
    BOOL _panoOnly;
    
    BOOL _atLeastOneFilterChanged;
    
    UIView *_footerView;
}

@synthesize settingsScreen, tableData, vwController, tblView, title, isOnlineMapSource;

- (id) initWithTable:(UITableView *)tableView viewController:(OAMapSettingsViewController *)viewController
{
    self = [super init];
    if (self)
    {
        _app = [OsmAndApp instance];
        _settings = [OAAppSettings sharedManager];
        settingsScreen = EMapSettingsScreenPOI;
        vwController = viewController;
        tblView = tableView;
        
        _mapillaryEnabled = _app.data.mapillary;
        _panoOnly = _settings.mapillaryFilterPano;
        
        NSString *usernames = _settings.mapillaryFilterUserName;
        NSString *userKeys = _settings.mapillaryFilterUserKey;
        _userNames = usernames ? usernames : @"";
        _userKeys = userKeys ? userKeys : @"";
        
        _startDate = _settings.mapillaryFilterStartDate;
        _endDate = _settings.mapillaryFilterEndDate;
        
        [self commonInit];
        [self initData];
    }
    return self;
}

- (void) dealloc
{
    [self deinit];
}

- (void) commonInit
{
    tblView.separatorColor = UIColorFromRGB(configure_screen_icon_color);
    [self.tblView.tableFooterView removeFromSuperview];
    self.tblView.tableFooterView = nil;
    [self buildFooterView];
}

- (void) onRotation
{
    [self.tblView reloadData];
}

- (void) deinit
{
}

- (void) initData
{
    _atLeastOneFilterChanged = NO;
    NSMutableArray *dataArr = [NSMutableArray new];
    
    // Visibility/cache section
    
    [dataArr addObject:@[
                         @{ @"type" : @"OADividerCell"},
                         @{
                             @"type" : @"OASettingSwitchCell",
                             @"title" : @"",
                             @"description" : @"",
                             @"img" : @"",
                             @"key" : @"mapillary_enabled"
                             },
                         @{
                             @"type" : @"OAIconTitleButtonCell",
                             @"title" : OALocalizedString(@"tile_cache"),
                             @"btnTitle" : OALocalizedString(@"shared_string_reload"),
                             @"description" : @"",
                             @"img" : @"ic_custom_overlay_map.png"
                             },
                         @{ @"type" : @"OADividerCell"}
                         ]];
    
    // Users filter
    [dataArr addObject:@[
                         @{ @"type" : @"OADividerCell"},
                         @{
                             @"type" : @"OAIconTitleValueCell",
                             @"img" : @"ic_custom_user.png",
                             @"key" : @"users_filter",
                             @"title" : OALocalizedString(@"mapil_usernames")
                             },
                         @{ @"type" : @"OADividerCell"}]];
    // Date filter
    [dataArr addObject:@[
                         @{ @"type" : @"OADividerCell"},
                         @{
                             @"type" : @"OATimeTableViewCell",
                             @"title" : OALocalizedString(@"shared_string_start_date"),
                             @"key" : @"start_date_filter",
                             @"img" : @"ic_custom_date.png"
                             },
                         @{
                             @"type" : @"OATimeTableViewCell",
                             @"title" : OALocalizedString(@"shared_string_end_date"),
                             @"key" : @"end_date_filter",
                             @"img" : @"ic_custom_date.png"
                             },
                         @{ @"type" : @"OADividerCell"}
                         ]];
    
    // Pano filter
    [dataArr addObject:@[
                         @{ @"type" : @"OADividerCell"},
                         @{
                             @"type" : @"OASettingSwitchCell",
                             @"title" : OALocalizedString(@"mapil_pano_only"),
                             @"description" : @"",
                             @"img" : @"ic_custom_coordinates.png",
                             @"key" : @"pano_only"
                             },
                         @{ @"type" : @"OADividerCell"}
                         ]];
    
    _data = [NSArray arrayWithArray:dataArr];
}

- (void) buildFooterView
{
    CGFloat distBetweenButtons = 21.0;
    CGFloat margin = [OAUtilities getLeftMargin];
    CGFloat width = self.tblView.frame.size.width;
    CGFloat height = 80.0;
    CGFloat buttonWidth = (width - 32 - distBetweenButtons) / 2;
    CGFloat buttonHeight = 44.0;
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    NSDictionary *applyAttrs = @{ NSFontAttributeName : [UIFont systemFontOfSize:15.0],
                             NSForegroundColorAttributeName : [UIColor whiteColor] };
    NSDictionary *resetAttrs = @{ NSFontAttributeName : [UIFont systemFontOfSize:15.0],
                                  NSForegroundColorAttributeName : UIColorFromRGB(color_menu_button) };
    NSAttributedString *resetText = [[NSAttributedString alloc] initWithString:OALocalizedString(@"shared_string_reset") attributes:resetAttrs];
    NSAttributedString *applyText = [[NSAttributedString alloc] initWithString:OALocalizedString(@"shared_string_apply") attributes:applyAttrs];
    UIButton *reset = [UIButton buttonWithType:UIButtonTypeSystem];
    UIButton *apply = [UIButton buttonWithType:UIButtonTypeSystem];
    [reset setAttributedTitle:resetText forState:UIControlStateNormal];
    [apply setAttributedTitle:applyText forState:UIControlStateNormal];
    [reset addTarget:self action:@selector(resetPressed) forControlEvents:UIControlEventTouchUpInside];
    [apply addTarget:self action:@selector(applyPressed) forControlEvents:UIControlEventTouchUpInside];
    reset.backgroundColor = UIColorFromRGB(color_disabled_light);
    apply.backgroundColor = UIColorFromRGB(color_active_light);
    reset.layer.cornerRadius = 9;
    apply.layer.cornerRadius = 9;
    reset.tag = resetButtonTag;
    apply.tag = applyButtonTag;
    CGFloat buttonY = (height / 2) - (buttonHeight / 2);
    reset.frame = CGRectMake(16.0 + margin, buttonY, buttonWidth, buttonHeight);
    apply.frame = CGRectMake(16.0 + margin + buttonWidth + distBetweenButtons, buttonY, buttonWidth, buttonHeight);
    [_footerView addSubview:reset];
    [_footerView addSubview:apply];
}

- (void) adjustFooterView:(CGFloat)width
{
    UIButton *reset = [_footerView viewWithTag:resetButtonTag];
    UIButton *apply = [_footerView viewWithTag:applyButtonTag];
    CGFloat height = 80.0;
    CGFloat distBetweenButtons = 21.0;
    CGFloat margin = [OAUtilities getLeftMargin];
    CGFloat buttonWidth = (width - 32 - distBetweenButtons - margin) / 2;
    CGFloat buttonHeight = 44.0;
    CGFloat buttonY = (height / 2) - (buttonHeight / 2);
    _footerView.frame = CGRectMake(_footerView.frame.origin.x, _footerView.frame.origin.y, width, height);
    reset.frame = CGRectMake(16.0 + margin, buttonY, buttonWidth, buttonHeight);
    apply.frame = CGRectMake(16.0 + margin + buttonWidth + distBetweenButtons, buttonY, buttonWidth, buttonHeight);
}

- (NSDictionary *)getItem:(NSIndexPath *)indexPath
{
    NSArray *section = _data[indexPath.section];
    if (indexPath.section == dateFilterSection)
    {
        if ([self datePickerIsShown])
        {
            if ([indexPath isEqual:_datePickerIndexPath])
                    return [NSDictionary new];
            else if (indexPath.row < section.count - 1)
                return section[indexPath.row];
            else
                return section[indexPath.row - 1];
        }
    }
    return section[indexPath.row];
}

- (void) setupView
{
    title = OALocalizedString(@"map_settings_mapillary");
}

- (BOOL)datePickerIsShown
{
    return _datePickerIndexPath != nil;
}

- (void) resetPressed
{
    [_settings setMapillaryFilterPano:NO];
    [_settings setMapillaryFilterUserKey:nil];
    [_settings setMapillaryFilterUserName:nil];
    [_settings setMapillaryFilterStartDate:0];
    [_settings setMapillaryFilterEndDate:0];
    [_settings setUseMapillaryFilter:NO];
    
    _panoOnly = _settings.mapillaryFilterPano;
    
    _userNames = @"";
    _userKeys = @"";
    
    _startDate = _settings.mapillaryFilterStartDate;
    _endDate = _settings.mapillaryFilterEndDate;
    
    _atLeastOneFilterChanged = YES;
    
    [self.tblView reloadData];
}

- (void) applyPressed
{
    [_settings setMapillaryFilterPano:_panoOnly];
    [_settings setMapillaryFilterUserKey:_userKeys];
    [_settings setMapillaryFilterUserName:_userNames];
    [_settings setMapillaryFilterStartDate:_startDate];
    [_settings setMapillaryFilterEndDate:_endDate];
    [_settings setUseMapillaryFilter:(_userNames && _userNames.length > 0) || _startDate != 0 || _endDate != 0 || _panoOnly];
    
    if (_atLeastOneFilterChanged)
        [self reloadCache];
    
    [vwController closeDashboard];
}

- (void) reloadCache
{
    OAMapPanelViewController *mapPanel = [OARootViewController instance].mapPanel;
    OAMapillaryLayer *layer = mapPanel.mapViewController.mapLayers.mapillaryLayer;
    [layer clearCacheAndUpdate];
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _data.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionItems = _data[section];
    if (section == dateFilterSection)
        return sectionItems.count + ([self datePickerIsShown] ? 1 : 0);
    
    return sectionItems.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *outCell;
    NSDictionary *item = [self getItem:indexPath];
    
    if ([item[@"type"] isEqualToString:@"OASettingSwitchCell"])
    {
        static NSString* const identifierCell = @"OASettingSwitchCell";
        OASettingSwitchCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OASettingSwitchCell" owner:self options:nil];
            cell = (OASettingSwitchCell *)[nib objectAtIndex:0];
        }
        
        if (cell)
        {
            cell.textView.text = item[@"title"];
            NSString *desc = item[@"description"];
            cell.descriptionView.text = desc;
            cell.descriptionView.hidden = desc.length == 0;
            NSString *key = item[@"key"];
            
            if ([key isEqualToString:@"mapillary_enabled"])
            {
                cell.textView.text = _mapillaryEnabled ? OALocalizedString(@"shared_string_enabled") : OALocalizedString(@"rendering_value_disabled_name");
                NSString *imgName = _mapillaryEnabled ? @"ic_custom_show.png" : @"ic_custom_hide.png";
                cell.imgView.image = [[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                cell.imgView.tintColor = _mapillaryEnabled ? UIColorFromRGB(color_dialog_buttons_dark) : UIColorFromRGB(configure_screen_icon_color);
                [cell.switchView setOn:_mapillaryEnabled];
            }
            else if ([key isEqualToString:@"pano_only"])
            {
                cell.imgView.image = [[UIImage imageNamed:item[@"img"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                cell.imgView.tintColor = _panoOnly ? UIColorFromRGB(color_dialog_buttons_dark) : UIColorFromRGB(configure_screen_icon_color);
                [cell.switchView setOn:_panoOnly];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.switchView.tag = indexPath.section << 10 | indexPath.row;
            [cell.switchView addTarget:self action:@selector(applyParameter:) forControlEvents:UIControlEventValueChanged];
        }
        outCell = cell;
    }
    else if ([item[@"type"] isEqualToString:@"OAIconTitleButtonCell"])
    {
        static NSString* const identifierCell = @"OAIconTitleButtonCell";
        OAIconTitleButtonCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OAIconTitleButtonCell" owner:self options:nil];
            cell = (OAIconTitleButtonCell *)[nib objectAtIndex:0];
        }
        
        if (cell)
        {
            cell.titleView.text = item[@"title"];
            cell.iconView.image = [[UIImage imageNamed:item[@"img"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            cell.iconView.tintColor = UIColorFromRGB(configure_screen_icon_color);
            [cell setButtonText:item[@"btnTitle"]];
            [cell.buttonView addTarget:self action:@selector(reloadCache) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        outCell = cell;
    }
    else if ([item[@"type"] isEqualToString:@"OAIconTitleValueCell"])
    {
        static NSString* const identifierCell = @"OAIconTitleValueCell";
        OAIconTitleValueCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OAIconTitleValueCell" owner:self options:nil];
            cell = (OAIconTitleValueCell *)[nib objectAtIndex:0];
        }
        if (cell)
        {
            cell.textView.text = item[@"title"];
            cell.leftImageView.image = [[UIImage imageNamed:item[@"img"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            cell.leftImageView.tintColor = UIColorFromRGB(configure_screen_icon_color);
            if ([item[@"key"] isEqualToString:@"users_filter"])
            {
                NSString *usernames = [_userNames stringByReplacingOccurrencesOfString:@"$$$" withString:@", "];
                cell.descriptionView.text = !usernames || usernames.length == 0 ? OALocalizedString(@"shared_string_all") : usernames;
            }
        }
        outCell = cell;
    }
    else if ([item[@"type"] isEqualToString:@"OADividerCell"])
    {
        static NSString* const identifierCell = @"OADividerCell";
        OADividerCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OADividerCell" owner:self options:nil];
            cell = (OADividerCell *)[nib objectAtIndex:0];
            cell.backgroundColor = UIColor.whiteColor;
            cell.dividerColor = UIColorFromRGB(configure_screen_icon_color);
            cell.dividerInsets = UIEdgeInsetsZero;
            cell.dividerHight = 0.5;
        }
        return cell;
    }
    else if ([item[@"type"] isEqualToString:@"OATimeTableViewCell"])
    {
        static NSString* const identifierCell = @"OATimeCell";
        OATimeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OATimeCell" owner:self options:nil];
            cell = (OATimeTableViewCell *)[nib objectAtIndex:0];
        }
        if (cell)
        {
            double dateVal = [item[@"key"] isEqualToString:@"start_date_filter"] ? _startDate : _endDate;
            BOOL isNotSet = dateVal == 0;
            cell.lbTitle.text = item[@"title"];
            UIImage *img = [[UIImage imageNamed:item[@"img"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            if (img)
            {
                [cell showLeftImageView:YES];
                cell.leftImageView.image = img;
                cell.leftImageView.tintColor = isNotSet ? UIColorFromRGB(configure_screen_icon_color) : UIColorFromRGB(color_dialog_buttons_dark);
            }
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
            [formatter setDateStyle:NSDateFormatterShortStyle];
            [formatter setTimeStyle:NSDateFormatterNoStyle];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateVal];
            NSString *dateStr = isNotSet ? OALocalizedString(@"shared_string_not_set") : [formatter stringFromDate:date];
            cell.lbTime.text = dateStr;
            [cell.lbTime setTextColor:isNotSet ? UIColorFromRGB(text_color_osm_note_bottom_sheet) : UIColorFromRGB(color_menu_button)];
        }
        outCell = cell;
    }
    else if ([self datePickerIsShown] && [_datePickerIndexPath isEqual:indexPath])
    {
        static NSString* const reusableIdentifierTimePicker = @"OADateTimePickerTableViewCell";
        OADateTimePickerTableViewCell* cell;
        cell = (OADateTimePickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reusableIdentifierTimePicker];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OADateTimePickerCell" owner:self options:nil];
            cell = (OADateTimePickerTableViewCell *)[nib objectAtIndex:0];
        }
        cell.dateTimePicker.datePickerMode = UIDatePickerModeDate;
        double currentDate = [[NSDate date] timeIntervalSince1970];
        double dateToShow = indexPath.row - 1 == 1 ? (_startDate == 0 ? currentDate : _startDate) : (_endDate == 0 ? currentDate : _endDate);
        cell.dateTimePicker.date = [NSDate dateWithTimeIntervalSince1970:dateToShow];
        [cell.dateTimePicker removeTarget:self action:NULL forControlEvents:UIControlEventValueChanged];
        [cell.dateTimePicker addTarget:self action:@selector(timePickerChanged:) forControlEvents:UIControlEventValueChanged];
        
        outCell = cell;
    }
    if (outCell)
        [self applySeparatorLine:outCell indexPath:indexPath];
    
    return outCell;
}

- (void) applySeparatorLine:(UITableViewCell *)outCell indexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionItems = _data[indexPath.section];
    BOOL timePickerSection = indexPath.section == dateFilterSection;
    BOOL lastItem = indexPath.row == (sectionItems.count + (timePickerSection && [self datePickerIsShown] ? 1 : 0) - 2);
    outCell.separatorInset = UIEdgeInsetsMake(0.0, lastItem ? 0.0 : 62.0, 0.0, lastItem ? DeviceScreenWidth : 0.0);
}

-(void)timePickerChanged:(id)sender
{
    UIDatePicker *picker = (UIDatePicker *)sender;
    NSDate *newDate = picker.date;
    if (_datePickerIndexPath.row == 2)
        _startDate = newDate.timeIntervalSince1970;
    else if (_datePickerIndexPath.row == 3)
        _endDate = newDate.timeIntervalSince1970;
    [self.tblView reloadData];
    
    _atLeastOneFilterChanged = YES;
}

- (void) applyParameter:(id)sender
{
    if ([sender isKindOfClass:[UISwitch class]])
    {
        UISwitch *sw = (UISwitch *) sender;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sw.tag & 0x3FF inSection:sw.tag >> 10];
        NSDictionary *item = [self getItem:indexPath];
        NSString *key = item[@"key"];
        if (key)
        {
            BOOL isChecked = sw.on;
            if ([key isEqualToString:@"mapillary_enabled"])
            {
                _mapillaryEnabled = isChecked;
                [_app.data setMapillary:_mapillaryEnabled];
            }
            else if ([key isEqualToString:@"pano_only"])
            {
                _panoOnly = isChecked;
                _atLeastOneFilterChanged = YES;
            }
            [self.tblView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case nameFilterSection:
            return 30.0;
        default:
            return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [self getFooterHeightForSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == panoImageFilterSection)
    {
        [self adjustFooterView:tableView.frame.size.width];
        return _footerView;
    }
    else
        return [self buildHeaderForSection:section width:tableView.frame.size.width];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if (section == nameFilterSection)
    {
        UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *) view;
        header.textLabel.textColor = UIColorFromRGB(text_color_osm_note_bottom_sheet);
    }
}

- (CGFloat) getFooterHeightForSection:(NSInteger) section
{
    if (section == panoImageFilterSection)
        return 80.0;
    else
    {
        NSString *text = section == visibilitySection ? OALocalizedString(@"mapil_reload_cache") : section == nameFilterSection ? OALocalizedString(@"mapil_filter_user_descr") : OALocalizedString(@"mapil_filter_date");
        CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}];
        return MAX(38.0, textSize.height + 16.0);
    }
}

- (UIView *) buildHeaderForSection:(NSInteger)section width:(NSInteger)width
{
    UILabel *label = [[UILabel alloc] init];
    label.text = section == visibilitySection ? OALocalizedString(@"mapil_reload_cache") : section == nameFilterSection ? OALocalizedString(@"mapil_filter_user_descr") : OALocalizedString(@"mapil_filter_date");
    UIFont *font = [UIFont systemFontOfSize:13];
    CGSize titleSize = [label.text sizeWithAttributes:@{NSFontAttributeName: font}];
    label.font = font;
    label.textColor = UIColorFromRGB(text_color_osm_note_bottom_sheet);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, MAX(38.0, titleSize.height + 16.0))];
    [view addSubview:label];
    label.frame = CGRectMake(16.0 + OAUtilities.getLeftMargin, 8.0, titleSize.width, titleSize.height);
    label.tag = section;
    return view;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case nameFilterSection:
            return OALocalizedString(@"shared_string_filter");
        default:
            return nil;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [self getItem:indexPath];
    if ([item[@"type"] isEqualToString:@"OASettingSwitchCell"])
    {
        return [OASettingSwitchCell getHeight:item[@"title"] desc:item[@"description"] hasSecondaryImg:NO cellWidth:tableView.bounds.size.width];
    }
    else if ([item[@"type"] isEqualToString:@"OAIconTitleButtonCell"])
    {
        [OAIconTitleButtonCell getHeight:item[@"title"] cellWidth:tableView.bounds.size.width];
    }
    else if ([item[@"type"] isEqualToString:@"OAIconTitleValueCell"])
    {
        NSString *usernames = _settings.mapillaryFilterUserName;
        usernames = !usernames || usernames.length == 0 ? OALocalizedString(@"shared_string_all") : usernames;
        [OAIconTitleValueCell getHeight:item[@"title"] value:usernames cellWidth:tableView.bounds.size.width];
    }
    else if ([indexPath isEqual:_datePickerIndexPath])
    {
        return 162.0;
    }
    else if ([item[@"type"] isEqualToString:@"OADividerCell"])
    {
        return [OADividerCell cellHeight:0.5 dividerInsets:UIEdgeInsetsZero];
    }
    return 44.0;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [self getItem:indexPath];
    NSString *type = item[@"type"];
    if ([type isEqualToString:@"OAIconTitleButtonCell"] || [type isEqualToString:@"OASettingSwitchCell"])
        return nil;
    return indexPath;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [self getItem:indexPath];
    if ([item[@"type"] isEqualToString:@"OATimeTableViewCell"])
    {
        [self.tblView beginUpdates];
        
        if ([self datePickerIsShown] && (_datePickerIndexPath.row - 1 == indexPath.row))
            [self hideExistingPicker];
        else
        {
            NSIndexPath *newPickerIndexPath = [self calculateIndexPathForNewPicker:indexPath];
            if ([self datePickerIsShown])
                [self hideExistingPicker];
            
            [self showNewPickerAtIndex:newPickerIndexPath];
            _datePickerIndexPath = [NSIndexPath indexPathForRow:newPickerIndexPath.row + 1 inSection:indexPath.section];
        }
        
        [self.tblView deselectRowAtIndexPath:indexPath animated:YES];
        [self.tblView endUpdates];
        [self.tblView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [self.tblView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if ([item[@"type"] isEqualToString:@"OAIconTitleValueCell"])
    {
        OAUsernameFilterViewController *controller = [[OAUsernameFilterViewController alloc] initWithData:@[_userNames, _userKeys]];
        controller.delegate = self;
        [self.vwController.navigationController pushViewController:controller animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)hideExistingPicker {
    
    [self.tblView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_datePickerIndexPath.row inSection:_datePickerIndexPath.section]]
                          withRowAnimation:UITableViewRowAnimationFade];
    _datePickerIndexPath = nil;
}

- (void)showNewPickerAtIndex:(NSIndexPath *)indexPath {
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:dateFilterSection]];
    
    [self.tblView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];
}

- (NSIndexPath *)calculateIndexPathForNewPicker:(NSIndexPath *)selectedIndexPath {
    NSIndexPath *newIndexPath;
    if (([self datePickerIsShown]) && (_datePickerIndexPath.row < selectedIndexPath.row))
        newIndexPath = [NSIndexPath indexPathForRow:selectedIndexPath.row - 1 inSection:dateFilterSection];
    else
        newIndexPath = [NSIndexPath indexPathForRow:selectedIndexPath.row  inSection:dateFilterSection];
    
    return newIndexPath;
}

#pragma mark - OAMapillaryScreenDelegate

- (void) setData:(NSArray<NSString*> *)data
{
    _userNames = data[0];
    _userKeys = data[1];
    _atLeastOneFilterChanged = YES;
    [self.tblView reloadData];
}

@end
