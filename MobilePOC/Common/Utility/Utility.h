
#pragma mark- Constants

#define kImageSize 48
#define WINDOW_WIDTH [[UIScreen mainScreen] bounds].size.width
#define WINDOW_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define USER_DEFAULT_SET_OBJECT(OBJECT,KEY) [[NSUserDefaults standardUserDefaults] setObject:OBJECT forKey:KEY]; [[NSUserDefaults standardUserDefaults] synchronize];
#define USER_DEFAULT_OBJECT(KEY) [[NSUserDefaults standardUserDefaults] objectForKey:KEY]
#define APPDELEGATE() ((AppDelegate *)[[UIApplication sharedApplication] delegate])


#ifdef DEBUG
#define Log(...) NSLog(__VA_ARGS__)
#else
#define Log(...)
#endif


#pragma mark- Color
#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define PRIMARY_COLOR    [UIColor colorWithRed:99.0f/255.0f green: 73.0f/255.0f blue:118.0f/255.0f alpha:1]
#define CELL_BACKGROUND_COLOR    [UIColor colorWithRed:239.0f/255.0f green: 241.0f/255.0f blue:245.0f/255.0f alpha:1]

#define STRIP(X)    [X stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]


#pragma mark- UIDevice Details
#define DEVICE_VERSION [UIDevice currentDevice].systemVersion
#define APP_ID [[NSBundle mainBundle] bundleIdentifier]
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#pragma mark- View Objects

#define IMAGEVIEW_IMAGE(ImageView,NAME) [ImageView setImage:[UIImage imageNamed:@NAME]];

#define BUTTONIMAGE(BUTTON,IMAGE) [BUTTON setImage:[UIImage imageNamed:@IMAGE] forState:UIControlStateNormal]

#define BUTTONTITLE(BUTTON,TITLE) [BUTTON setTitle:@TITLE forState:UIControlStateNormal]

#define  BUTTON_ADD_TARGET(BUTTON,TARGET,SELECTOR) [BUTTON addTarget:TARGET action:@selector(SELECTOR) forControlEvents:UIControlEventTouchUpInside];

#define BARBUTTONTITLE(TITLE, SELECTOR)     [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]
#define BARBUTTONIMAGE(IMAGE, SELECTOR)     [[UIBarButtonItem alloc] initWithImage:IMAGE style:UIBarButtonItemStylePlain target:self action:SELECTOR]

#define SYSBARBUTTON(ITEM, SELECTOR) [[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:self action:SELECTOR]

#define IS_PORTRAIT UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) || UIDeviceOrientationIsPortrait(self.interfaceOrientation)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define ESTABLISH_WEAK_SELF __weak typeof(self) weakSelf = self
#define ESTABLISH_STRONG_SELF __strong typeof(self) strongSelf = weakSelf;


#pragma mark - Constraints
#define PREPCONSTRAINTS(VIEW) [VIEW setTranslatesAutoresizingMaskIntoConstraints:NO]
#define CONSTRAIN(PARENT, VIEW, FORMAT) [PARENT addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:(FORMAT) options:0 metrics:nil views:NSDictionaryOfVariableBindings(VIEW)]]
#define CONSTRAIN_VIEWS(PARENT, FORMAT, VIEWBINDINGS) [PARENT addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:(FORMAT) options:0 metrics:nil views:VIEWBINDINGS]]

// Stretch across axis
#define STRETCH_VIEW_H(PARENT, VIEW) 2(PARENT, VIEW, @"H:|["#VIEW"(>=0)]|")
#define STRETCH_VIEW_V(PARENT, VIEW) CONSTRAIN(PARENT, VIEW, @"V:|["#VIEW"(>=0)]-8-|")
#define STRETCH_VIEW(PARENT, VIEW) {STRETCH_VIEW_H(PARENT, VIEW); STRETCH_VIEW_V(PARENT, VIEW);}

// Center along axis
#define CENTER_VIEW_H(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]]
#define CENTER_VIEW_V(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]]
#define CENTER_VIEW(PARENT, VIEW) {CENTER_VIEW_H(PARENT, VIEW); CENTER_VIEW_V(PARENT, VIEW);}

// Align to parent
#define ALIGN_VIEW_LEFT(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]]
#define ALIGN_VIEW_RIGHT(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]]
#define ALIGN_VIEW_TOP(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]]
#define ALIGN_VIEW_BOTTOM(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]]
#define ALIGN_VIEW_LEFT_CONSTANT(PARENT, VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeLeft multiplier:1.0f constant:CONSTANT]]
#define ALIGN_VIEW_RIGHT_CONSTANT(PARENT, VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeRight multiplier:1.0f constant:CONSTANT]]
#define ALIGN_VIEW_TOP_CONSTANT(PARENT, VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeTop multiplier:1.0f constant:CONSTANT]]
#define ALIGN_VIEW_BOTTOM_CONSTANT(PARENT, VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeBottom multiplier:1.0f constant:CONSTANT]]


#define ALIGN_VIEW_TOP_TO_VIEW_CONSTANT(PARENT, VIEW, TO_VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:TO_VIEW attribute:NSLayoutAttributeTop multiplier:1.0f constant:CONSTANT]]

#define ALIGN_VIEW_LEFT_TO_VIEW_CONSTANT(PARENT, VIEW, TO_VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:TO_VIEW attribute:NSLayoutAttributeLeading multiplier:1.0f constant:CONSTANT]]

#define ALIGN_VIEW_RIGHT_TO_VIEW_CONSTANT(PARENT, VIEW, TO_VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:TO_VIEW attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:CONSTANT]]


#define ALIGN_VIEW_BOTTOM_TO_VIEW_CONSTANT(PARENT, VIEW, TO_VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:TO_VIEW attribute:NSLayoutAttributeBottom multiplier:1.0f constant:CONSTANT]]

#define ALIGN_VIEW_TOP_TO_VIEW_BOTTOM_CONSTANT(PARENT, VIEW, TO_VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:TO_VIEW attribute:NSLayoutAttributeBottom multiplier:1.0f constant:CONSTANT]]

#define ALIGN_VIEW_BOTTOM_TO_VIEW_TOP_CONSTANT(PARENT, VIEW, TO_VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:TO_VIEW attribute:NSLayoutAttributeTop multiplier:1.0f constant:CONSTANT]]

#define ALIGN_VIEW_RIGHT_TO_VIEW_LEFT_CONSTANT(PARENT, VIEW, TO_VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:TO_VIEW attribute:NSLayoutAttributeLeading multiplier:1.0f constant:CONSTANT]]

#define ALIGN_VIEW_LEFT_TO_VIEW_RIGHT_CONSTANT(PARENT, VIEW, TO_VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:TO_VIEW attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:CONSTANT]]


// Set Size
#define CONSTRAIN_WIDTH(VIEW, WIDTH) [VIEW addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:WIDTH]];
#define CONSTRAIN_HEIGHT(VIEW, HEIGHT) [VIEW addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:HEIGHT]];
#define CONSTRAIN_SIZE(VIEW, HEIGHT, WIDTH) {CONSTRAIN_WIDTH(VIEW, WIDTH); CONSTRAIN_HEIGHT(VIEW, HEIGHT);}

// Set Aspect
#define CONSTRAIN_ASPECT(VIEW, ASPECT) [VIEW addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:VIEW attribute:NSLayoutAttributeHeight multiplier:(ASPECT) constant:0.0f]]


