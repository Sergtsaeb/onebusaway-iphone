//
//  OBASettingsViewController.m
//  org.onebusaway.iphone
//
//  Created by Aaron Brethorst on 11/6/16.
//  Copyright © 2016 OneBusAway. All rights reserved.
//

#import "OBASettingsViewController.h"
@import OBAKit;
@import GoogleAnalytics;
#import "OBASwitchRow.h"

@interface OBASettingsViewController ()

@end

@implementation OBASettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"msg_settings", @"title of OBASettingsViewController");

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close)];

    [self loadData];
}

#pragma mark - Actions

- (void)close {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Data Loading

- (void)loadData {
    OBATableSection *analyticsSection = [self buildAnalyticsSection];
    OBATableSection *crashReportingSection = [self buildCrashReportingSection];
    OBATableSection *ratePromptSection = [self buildRatePromptSection];
    
    self.sections = @[analyticsSection, crashReportingSection, ratePromptSection];
    [self.tableView reloadData];
}

- (OBATableSection*)buildAnalyticsSection {
    OBATableSection *analyticsSection = [[OBATableSection alloc] initWithTitle:nil];

    BOOL analyticsValue = [[NSUserDefaults standardUserDefaults] boolForKey:OBAOptInToTrackingDefaultsKey];
    OBASwitchRow *switchRow = [[OBASwitchRow alloc] initWithTitle:NSLocalizedString(@"msg_enable_google_analytics", @"A switch option's text for enabling and disabling Google Analytics") action:^{
        [[NSUserDefaults standardUserDefaults] setBool:!analyticsValue forKey:OBAOptInToTrackingDefaultsKey];
        [GAI sharedInstance].optOut = !analyticsValue;
    } switchValue:analyticsValue];
    [analyticsSection addRow:switchRow];

    analyticsSection.footerView = [OBAUIBuilder footerViewWithText:NSLocalizedString(@"msg_explanatory_google_analytics", @"Analytics explanation on the Settings view controller.") maximumWidth:CGRectGetWidth(self.tableView.frame)];

    return analyticsSection;
}

- (OBATableSection*)buildCrashReportingSection {
    OBATableSection *section = [[OBATableSection alloc] initWithTitle:nil];

    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:OBAOptInToCrashReportingDefaultsKey];
    OBASwitchRow *switchRow = [[OBASwitchRow alloc] initWithTitle:NSLocalizedString(@"settings.crash_reporting.switch_text", @"A switch option's text for enabling and disabling crash reporting") action:^{
        [[NSUserDefaults standardUserDefaults] setBool:!value forKey:OBAOptInToCrashReportingDefaultsKey];
    } switchValue:value];
    [section addRow:switchRow];

    section.footerView = [OBAUIBuilder footerViewWithText:NSLocalizedString(@"settings.crash_reporting.footer", @"Crash reporting explanation on the Settings view controller.") maximumWidth:CGRectGetWidth(self.tableView.frame)];

    return section;
}

// Disable review requests - issue #854
- (OBATableSection*)buildRatePromptSection {
    OBATableSection *ratePromptSection = [[OBATableSection alloc] initWithTitle:nil];

    BOOL ratePromptValue = [[NSUserDefaults standardUserDefaults] boolForKey:OBAAllowReviewPromptsDefaultsKey];
    OBASwitchRow *ratePromptRow = [[OBASwitchRow alloc] initWithTitle:NSLocalizedString(@"msg_allow_app_feedback", @"A switch option's text for enabling and disabling App Store review prompts") action:^{
        [[NSUserDefaults standardUserDefaults] setBool:!ratePromptValue forKey:OBAAllowReviewPromptsDefaultsKey];
    }switchValue:ratePromptValue];
    [ratePromptSection addRow:ratePromptRow];

    // Get rid of the really annoying cell seperator
    ratePromptSection.footerView = [OBAUIBuilder footerViewWithText:NSLocalizedString(@"msg_explanatory_allow_app_feedback", @"App feedback explanation on the Settings view controller.") maximumWidth:CGRectGetWidth(self.tableView.frame)];

    return ratePromptSection;
}

@end
