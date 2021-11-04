
#import "LRSPlaceholderTextView.h"

@interface LRSPlaceholderTextView()
@property (nonatomic, strong) UILabel *placeHolderLabel;
@end

@implementation LRSPlaceholderTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self build];
        [self setup];
        [self addSubview:self.placeHolderLabel];
    }
    return self;
}

#pragma mark - Setters

- (void)setPlaceHolder:(NSString *)placeHolder {
    if ([placeHolder isEqualToString:_placeHolder]) {
        return;
    }
    _placeHolder = placeHolder;
    self.placeHolderLabel.text = _placeHolder;
}

- (void)setPlaceHolderTextColor:(UIColor *)placeHolderTextColor {
    if ([placeHolderTextColor isEqual:_placeHolderTextColor]) {
        return;
    }

    _placeHolderTextColor = placeHolderTextColor;
    self.placeHolderLabel.textColor = _placeHolderTextColor;
}

#pragma mark - Text view overrides

- (void)setText:(NSString *)text {
    [super setText:text];
    self.placeHolderLabel.hidden = !([self.text length] == 0 && self.placeHolder);
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    self.placeHolderLabel.hidden = !([self.text length] == 0 && self.placeHolder);
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeHolderLabel.font = font;
}

#pragma mark - Notifications

- (void)didReceiveTextDidChangeNotification:(NSNotification *)notification {
    self.placeHolderLabel.hidden = !([self.text length] == 0 && self.placeHolder);
}

#pragma mark - Life cycle

- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveTextDidChangeNotification:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];

    _placeHolderTextColor = [UIColor lightGrayColor];
    _placeHolder = @"";
}

- (void)build {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 8.0f);
    self.contentInset = UIEdgeInsetsZero;
    self.scrollEnabled = YES;
    self.scrollsToTop = NO;
    self.userInteractionEnabled = YES;
    self.font = [UIFont systemFontOfSize:16.0f];
    self.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
    self.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.keyboardType = UIKeyboardTypeDefault;
    self.returnKeyType = UIReturnKeyDefault;
    self.textAlignment = NSTextAlignmentLeft;
}

- (void)dealloc {
    _placeHolder = nil;
    _placeHolderTextColor = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}


- (UILabel *)placeHolderLabel {
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, [UIScreen mainScreen].bounds.size.width, 20)];
        _placeHolderLabel.textColor = [UIColor lightGrayColor];
        _placeHolderLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    return _placeHolderLabel;
}
@end
