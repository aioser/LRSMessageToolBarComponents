

#import "LRSMemePackagesView.h"
#import "LRSMemePackageControlView.h"
#import "LRSMemePackageConfigure.h"
#import "LRSMessageToolBarHelper.h"
#import <MASonry/MASonry.h>

@interface LRSMemePackagesView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIButton *sendEmojiButton;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIScrollView *barScrollView;
@property (nonatomic, strong) NSArray<LRSMemePackageConfigure *> *configures;
@end


@implementation LRSMemePackagesView

- (instancetype)initWithFrame:(CGRect)frame configures:(NSArray<LRSMemePackageConfigure *> *)configures {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.mainScrollView];
        [self addSubview:self.barScrollView];
        [self addSubview:self.sendEmojiButton];
        self.configures = configures;
    }
    return self;
}

- (void)buildUI {
    NSArray<LRSMemePackageConfigure *> *configures = self.configures;
    UIView *mainContentView = [[UIView alloc] init];
    [self.mainScrollView addSubview:mainContentView];
    [mainContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.mainScrollView);
    }];
    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.barScrollView.mas_top);
    }];
    UIView *barContentView = [[UIView alloc] init];
    [self.barScrollView addSubview:barContentView];
    [barContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.barScrollView);
    }];
    [self.barScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self.sendEmojiButton.mas_left);
        make.height.equalTo(self.sendEmojiButton);
        make.centerY.equalTo(self.sendEmojiButton);
    }];

    for (NSInteger index = 0; index < configures.count; ++ index) {
        LRSMemePackageConfigure *configure = configures[index];
        LRSMemePackageControlView *emojiView = [[LRSMemePackageControlView alloc] initWithEmojis:configure.emojis row:configure.row column:configure.column];
        [mainContentView addSubview:emojiView];
        emojiView.itemHandler = self.itemHandler;
        emojiView.backspaceHandler = self.backspaceHandler;
        [emojiView buildUIWithTotalHeight:LRSMemePackagesView.memeBoardHeight];
        [emojiView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([self screenWidth] * index);
            make.top.bottom.equalTo(mainContentView);
            make.width.mas_equalTo([self screenWidth]);
            if (index == configures.count - 1) {
                make.right.equalTo(mainContentView);
            }
            make.height.mas_equalTo(LRSMemePackagesView.memeBoardHeight);
        }];

        UIButton *coverButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [coverButton setImage:[LRSMessageToolBarHelper imageNamed:configure.coverImageName] forState:(UIControlStateNormal)];
        coverButton.backgroundColor = [LRSMessageToolBarHelper colorNamed:@"Color_244"];
        [barContentView addSubview:coverButton];
        [coverButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(60 * index);
            make.top.bottom.equalTo(barContentView);
            make.width.mas_equalTo(60);
            if (index == configures.count - 1) {
                make.right.equalTo(barContentView);
            }
            make.height.mas_equalTo(LRSMemePackagesView.actionButtonHeight);
        }];
    }

    [self.sendEmojiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.bottom.mas_equalTo(-LRSMessageToolBarHelper.safeAreaHeight);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(LRSMemePackagesView.actionButtonHeight);
    }];
}

+ (CGFloat)boardHeight {
    return [self memeBoardHeight] + [LRSMessageToolBarHelper safeAreaHeight] + [self actionButtonHeight];
}

+ (CGFloat)memeBoardHeight {
    return 213;
}

+ (CGFloat)actionButtonHeight {
    return 40;
}

- (CGFloat)screenWidth {
    return [LRSMessageToolBarHelper screenWidth];
}

#pragma mark - 表情代理方法

- (UIButton *)sendEmojiButton {
    if (!_sendEmojiButton) {
        _sendEmojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendEmojiButton setBackgroundImage:[LRSMessageToolBarHelper imageNamed:@"information_send"] forState:UIControlStateNormal];
        [_sendEmojiButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendEmojiButton setTitleColor:[LRSMessageToolBarHelper colorNamed:@"Color_30"] forState:UIControlStateNormal];
        _sendEmojiButton.titleLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightSemibold];
        _sendEmojiButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [[_sendEmojiButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _sendEmojiButton;
}

- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        _mainScrollView = scrollView;
    }
    return _mainScrollView;
}

- (UIScrollView *)barScrollView {
    if (!_barScrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        _barScrollView = scrollView;
    }
    return _barScrollView;
}
@end
