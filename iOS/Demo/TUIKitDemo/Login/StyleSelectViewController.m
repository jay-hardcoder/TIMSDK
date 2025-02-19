//
//  StyleSelectViewController.m
//  TUIKitDemo
//
//  Created by wyl on 2022/11/7.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "StyleSelectViewController.h"
#import "TUIDarkModel.h"
#import "TUIGlobalization.h"
#import "TUIThemeManager.h"
#import "TUIDefine.h"

@implementation StyleSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)setCellModel:(StyleSelectCellModel *)cellModel
{
    _cellModel = cellModel;
    
    self.nameLabel.text = cellModel.styleName;
    self.chooseIconView.hidden = !cellModel.selected;
}

- (void)setupViews
{
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.chooseIconView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.chooseIconView.frame = CGRectMake(self.contentView.mm_w - 16 - 20, 0.5 * (self.contentView.mm_h - 20), 20, 20);
    self.nameLabel.frame = CGRectMake(16, 0, self.contentView.mm_w - 3 * 16 - 20, self.contentView.mm_h);
}

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:16.0];
        _nameLabel.text = @"1233";
        _nameLabel.textColor = TUICoreDynamicColor(@"form_title_color", @"#000000");
    }
    return _nameLabel;
}

- (UIImageView *)chooseIconView
{
    if (_chooseIconView == nil) {
        _chooseIconView = [[UIImageView alloc] init];
        _chooseIconView.image = [UIImage imageNamed:@"choose"];
    }
    return _chooseIconView;
}

@end

@implementation StyleSelectCellModel


@end

@interface StyleSelectViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) TUINaviBarIndicatorView *titleView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) StyleSelectCellModel *selectModel;

@end

@implementation StyleSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self prepareData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithDefaultBackground];
        appearance.shadowColor = nil;
        appearance.backgroundEffect = nil;
        appearance.backgroundColor =  self.tintColor;
        self.navigationController.navigationBar.backgroundColor = self.tintColor;
        self.navigationController.navigationBar.barTintColor = self.tintColor;
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.standardAppearance = appearance;
        /**
         * iOS15 新增特性：滑动边界样式
         * New feature in iOS15: sliding border style
         */
        self.navigationController.navigationBar.scrollEdgeAppearance= appearance;

    }
    else {
        self.navigationController.navigationBar.backgroundColor = self.tintColor;
        self.navigationController.navigationBar.barTintColor = self.tintColor;
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.translucent = NO;

    }
    self.navigationController.navigationBarHidden = NO;

}

- (UIColor *)tintColor
{
    return TUICoreDynamicColor(@"head_bg_gradient_start_color", @"#EBF0F6");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)setupViews
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    /**
     * 不设置会导致一些位置错乱，无动画等问题
     * Not setting it will cause some problems such as confusion in position, no animation, etc.
     */
    self.definesPresentationContext = YES;
    
    self.navigationController.navigationBarHidden = NO;
    _titleView = [[TUINaviBarIndicatorView alloc] init];
    [_titleView setTitle:NSLocalizedString(@"ChangeStyle", nil)];
    self.navigationItem.titleView = _titleView;
    self.navigationItem.title = @"";
    
    UIImage *image = TUICoreDynamicImage(@"nav_back_img", [UIImage imageNamed:@"ic_back_white"]);
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.hidesBackButton = YES;
    
    [self.view addSubview:self.tableView];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareData
{
    StyleSelectCellModel *classic = [[StyleSelectCellModel alloc] init];
    classic.styleID = @"Classic";
    classic.styleName = NSLocalizedString(@"Classic", nil);
    classic.selected = NO;
    
    StyleSelectCellModel *mini = [[StyleSelectCellModel alloc] init];
    mini.styleID = @"Minimalist";
    mini.styleName = NSLocalizedString(@"Minimalist", nil);
    mini.selected = NO;
    
    self.datas = [NSMutableArray arrayWithArray:@[classic, mini]];
    
    NSString *styleID = [[NSUserDefaults standardUserDefaults] objectForKey:@"StyleSelectkey"];
    
    for (StyleSelectCellModel *cellModel in self.datas) {
        if ([cellModel.styleID isEqual:styleID]) {
            cellModel.selected = YES;
            self.selectModel = cellModel;
            break;
        }
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StyleSelectCellModel *cellModel = self.datas[indexPath.row];
    StyleSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.cellModel = cellModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    StyleSelectCellModel *cellModel = self.datas[indexPath.row];

    [[NSUserDefaults standardUserDefaults] setValue:cellModel.styleID forKey:@"StyleSelectkey"];
    [NSUserDefaults.standardUserDefaults synchronize];
    /**
     * 处理 UI 选中
     * Handling UI selection
     */
    self.selectModel.selected = NO;
    cellModel.selected = YES;
    self.selectModel = cellModel;
    [tableView reloadData];
    
    /**
     * 通知页面动态刷新
     * Notify page dynamic refresh
     */
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([weakSelf.delegate respondsToSelector:@selector(onSelectStyle:)]) {
            [weakSelf.delegate onSelectStyle:cellModel];
        }
    });
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_tableView registerClass:StyleSelectCell.class forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

+ (NSString *)getCurrentStyleSelectID {
    NSString *styleID = [[NSUserDefaults standardUserDefaults] objectForKey:@"StyleSelectkey"];
    if (IS_NOT_EMPTY_NSSTRING(styleID)) {
        return styleID;
    }
    else {
        //First Init
        NSString * initStyleID = @"Classic";
        [[NSUserDefaults standardUserDefaults] setValue:initStyleID forKey:@"StyleSelectkey"];
        [NSUserDefaults.standardUserDefaults synchronize];
        return initStyleID;
    }
}

+ (BOOL)isClassicEntrance {
    NSString *styleID = [self.class getCurrentStyleSelectID];
    if ([styleID isKindOfClass:NSString.class]) {
        if (styleID.length > 0) {
            if ([styleID isEqualToString:@"Classic"] ) {
                return YES;
            }
        }
    }
    return NO;
}

@end
