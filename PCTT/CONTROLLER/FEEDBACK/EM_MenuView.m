//
//  EM_MenuView.m
//  Emoticon
//
//  Created by thanhhaitran on 2/7/16.
//  Copyright © 2016 thanhhaitran. All rights reserved.
//

#import "EM_MenuView.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface EM_MenuView ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSMutableArray * dataList, * tempList;
    
    NSMutableDictionary * extraInfo, * multiSection;
    
    NSTimer * timer;
    
    NSString * gName, * uName;
    
    NSMutableArray *years;
}

@end

@implementation EM_MenuView

@synthesize menuCompletion;

- (id)initWithPreviewMenu:(NSDictionary*)info
{
    self = [self init];
    
    [self setContainerView:[self didCreatePreviewView:info]];
    
    [self setUseMotionEffects:true];
    
    return self;
}

- (UIView*)didCreatePreviewView:(NSDictionary*)dict
{
    UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight - 0)];
    
    [commentView setBackgroundColor:[UIColor clearColor]];
    
    UIView *contentView = [[NSBundle mainBundle] loadNibNamed:@"EM_Menu" owner:self options:nil][7];
    
    contentView.frame = CGRectMake(0, 0, commentView.frame.size.width, commentView.frame.size.height);
    
    if ([dict[@"image"] isKindOfClass:[NSString class]]) {
        [(UIImageView*)[self withView:contentView tag:11] sd_setImageWithURL:[NSURL URLWithString:dict[@"image"]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
    } else {
        ((UIImageView*)[self withView:contentView tag:11]).image = dict[@"image"];
    }
    
    [((UIButton*)[self withView:contentView tag:12]) actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        [self close];
    }];
    
    [commentView addSubview:contentView];
    
    return commentView;
}


- (id)initWithSettingMenu:(NSDictionary*)info
{
    self = [self init];
    
    [self setContainerView:[self didCreateSettingView:info]];
    
    [self setUseMotionEffects:true];
    
    return self;
}

- (UIView*)didCreateSettingView:(NSDictionary*)dict
{
    UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 310, 135)];
    
    [commentView setBackgroundColor:[UIColor clearColor]];
    
    UIView *contentView = [[NSBundle mainBundle] loadNibNamed:@"EM_Menu" owner:self options:nil][8];
    
    contentView.frame = CGRectMake(0, 0, commentView.frame.size.width, commentView.frame.size.height);
    
    
    [(UIView*)[self withView:contentView tag:111] actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        self.menuCompletion(1, @{}, self);
        [self close];
    }];
    
    
    [(UIView*)[self withView:contentView tag:222] actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        self.menuCompletion(2, @{}, self);
        [self close];
    }];
    
    [(UIView*)[self withView:contentView tag:333] actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        self.menuCompletion(3, @{}, self);
        [self close];
    }];
  
    [commentView addSubview:contentView];
    
    return commentView;
}

- (id)initWithLoc:(NSDictionary*)info
{
    self = [self init];
    
    [self setContainerView:[self didCreateLocView:info]];
    
    [self setUseMotionEffects:true];
    
    return self;
}

- (UIView*)didCreateLocView:(NSDictionary*)dict
{
    UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 310, 460)];
    
    [commentView setBackgroundColor:[UIColor clearColor]];
    
    UIView *contentView = [[NSBundle mainBundle] loadNibNamed:@"EM_Menu" owner:self options:nil][5];
    
    contentView.frame = CGRectMake(0, 0, commentView.frame.size.width, commentView.frame.size.height);
    
    
//    [(UIImageView*)[self withView:contentView tag:11] imageUrl:dict[@"url"]];
    
//    [(UIImageView*)[self withView:contentView tag:11] withBorder:@{@"Bwidth":@(1), @"Bcolor": [UIColor brownColor]}];
    
    [(UIButton*)[self withView:contentView tag:12] actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        [self close];
    }];
    
  
    
    [contentView actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        //self.menuCompletion(0, dict, self);
    }];
    
    [commentView addSubview:contentView];
    
    return commentView;
}

- (NSDictionary*) lang
{
    BOOL isVi = [[self getValue:@"lang"]  isEqualToString: @"vi"] ? YES : NO;
    
    NSDictionary * vi = @{@"1":@"Tuỳ chọn", @"2":@"English",@"3":@"Cài đặt thông báo", @"4":@"Giới thiệu 3DART",@"5":@"Hướng dẫn tham quan", @"6":@"Thoát"};
    
    NSDictionary * en = @{@"1":@"Options", @"2":@"Vietnamese",@"3":@"Notification", @"4":@"3DART's introduction",@"5":@"Tour instruction", @"6":@"Exit"};
    
    return isVi ? vi : en ;
}

- (id)initWithPop:(NSDictionary*)info
{
    self = [self init];
    
    [self setContainerView:[self didCreatePopView:info]];
    
    [self setUseMotionEffects:true];
    
    return self;
}

- (UIView*)didCreatePopView:(NSDictionary*)dict
{
    BOOL delete = [dict responseForKey:@"delete"];
    
    UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, delete ? 267 : 195)];
    
    [commentView setBackgroundColor:[UIColor clearColor]];
    
    UIView *contentView = [[NSBundle mainBundle] loadNibNamed:@"EM_Menu" owner:self options:nil][delete ? 9 : 4];
    
    contentView.frame = CGRectMake(0, 0, commentView.frame.size.width, commentView.frame.size.height);
    
    [contentView setBackgroundColor:[UIColor clearColor]];

    [self setBackgroundColor:[UIColor clearColor]];

    UILabel * lat = ((UILabel*)[self withView:contentView tag:11]);
    
    lat.text = [NSString stringWithFormat:@"Kinh độ: %@", [dict getValueFromKey:@"lat"]];
        
    UILabel * lng = ((UILabel*)[self withView:contentView tag:12]);

    lng.text = [NSString stringWithFormat:@"Vĩ độ: %@", [dict getValueFromKey:@"lng"]];
    
    if (delete) {
        ((UILabel*)[self withView:contentView tag:10]).text = [dict getValueFromKey:@"loc_name"];

        ((UILabel*)[self withView:contentView tag:13]).text = [NSString stringWithFormat:@"Nhiệt độ: %.2f °C", (([dict[@"temp"] floatValue] -  273.15) * 1)];

        ((UILabel*)[self withView:contentView tag:14]).text = [NSString stringWithFormat:@"Áp suất: %@ hpa",[dict getValueFromKey:@"pressure"]];

        ((UILabel*)[self withView:contentView tag:15]).text = [NSString stringWithFormat:@"Độ ẩm: %@ %@",[dict getValueFromKey:@"humidity"], @"%"];

        ((UILabel*)[self withView:contentView tag:16]).text = [NSString stringWithFormat:@"Tốc độ gió: %.2f m/s",[dict[@"wind"] floatValue]];

    } else {
        UITextField * textField = ((UITextField*)[self withView:contentView tag:14]);
          
        textField.delegate = self;
    }
        
    [(UIButton*)[self withView:contentView tag:19] actionForTouch:@{} and:^(NSDictionary *touchInfo) {
           
       [self close];

    }];
    
    [(UIButton*)[self withView:contentView tag:20] actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        if (delete) {
            self.menuCompletion(21, @{@"id":[dict getValueFromKey: @"id"]}, self);
        } else {
           if ([[((UITextField*)[self withView:contentView tag:14]).text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
                
                [((UITextField*)[self withView:contentView tag:14]) resignFirstResponder];
                
                [self showToast:@"Tên địa điểm trống" andPos:0];
                
                return;
           }
            
           self.menuCompletion(20, @{@"name": ((UITextField*)[self withView:contentView tag:14]).text, @"lat": [dict getValueFromKey:@"lat"], @"lng": [dict getValueFromKey:@"lng"]}, self);
        }
        
        [self close];
    }];
    
    [commentView addSubview:contentView];
    
    return commentView;
}

- (id)initWithMenu:(NSDictionary*)info
{
    self = [self init];
    
    [self setContainerView:[self didCreateMenuView:info]];
    
    [self setUseMotionEffects:true];
    
    return self;
}

- (UIView*)didCreateMenuView:(NSDictionary*)dict
{
    UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 155)];
    
    [commentView withBorder:@{@"Bcolor": [UIColor clearColor], @"Bcorner":@(5), @"Bwidth":@(0)}];
    
    UIView *contentView = [[NSBundle mainBundle] loadNibNamed:@"EM_Menu" owner:self options:nil][0];
    
    contentView.frame = CGRectMake(0, 0, commentView.frame.size.width, commentView.frame.size.height);
    
    for(UIView * v in contentView.subviews)
    {
        if([v isKindOfClass:[UIButton class]])
        {
            [(UIButton*)[self withView:contentView tag:v.tag] actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        
                [self close];
        
                self.menuCompletion(v.tag, nil, self);
            }];
        } else {
            [((UIView*)v) withShadow];
        }
    }

    [commentView addSubview:contentView];
    
    return commentView;
}

- (id)initWithNotification:(NSDictionary*)info
{
    self = [self init];
    
    [self setContainerView:[self didCreateNotificationView:info]];
    
    [self setUseMotionEffects:true];
    
    return self;
}

- (UIView*)didCreateNotificationView:(NSDictionary*)dict
{
    dataList = [[NSMutableArray alloc] initWithArray:dict[@"data"]];
    
    UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, dataList.count == 0 ? 100 : dataList.count >= 4 ? (4 * 60) + 60 : (dataList.count * 60) + 60)];
    
    [commentView withBorder:@{@"Bcolor":[UIColor whiteColor],@"Bcorner":@(5),@"Bwidth":@(0)}];
    
    UIView* contentView = [[NSBundle mainBundle] loadNibNamed:@"EM_Menu" owner:self options:nil][1];
    
    contentView.frame = CGRectMake(0, 0, commentView.frame.size.width, commentView.frame.size.height);
    
    
    
    UITableView * tableView = (UITableView*)[self withView:contentView tag:11];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;

    
    [(UIButton*)[self withView:contentView tag:111] actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        if(self.menuCompletion)
            self.menuCompletion(100, @{@"data": self->dataList}, self);
    }];
    
    [commentView addSubview:contentView];
    
    [tableView reloadData];
    
    [tableView cellVisible];
    
    return commentView;
}

- (id)initWithFilter:(NSDictionary*)info
{
    self = [self init];
    
    [self setContainerView:[self didCreateFilterView:info]];
    
    [self setUseMotionEffects:true];
    
    return self;
}

- (UIView*)didCreateFilterView:(NSDictionary*)dict
{
    dataList = [[NSMutableArray alloc] initWithArray:dict[@"data"]];
    
    UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, dataList.count == 0 ? 100 : dataList.count >= 10 ? (4 * 60) + 60 : (dataList.count * 60) + 60)];
    
    [commentView withBorder:@{@"Bcolor":[UIColor whiteColor],@"Bcorner":@(5),@"Bwidth":@(0)}];
    
    UIView* contentView = [[NSBundle mainBundle] loadNibNamed:@"EM_Menu" owner:self options:nil][10];
    
    contentView.frame = CGRectMake(0, 0, commentView.frame.size.width, commentView.frame.size.height);
    
    
    
    UITableView * tableView = (UITableView*)[self withView:contentView tag:11];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;

    
    [(UIButton*)[self withView:contentView tag:111] actionForTouch:@{} and:^(NSDictionary *touchInfo) {
//        if(self.menuCompletion)
//            self.menuCompletion(100, @{@"data": self->dataList}, self);
    }];
    
    [commentView addSubview:contentView];
    
    [tableView reloadData];
    
    [tableView cellVisible];
    
    return commentView;
}

- (id)initWithDate:(NSDictionary*)info
{
    self = [self init];
    
    [self setContainerView:[self didCreateDateView:info]];
    
    [self setUseMotionEffects:true];
    
    return self;
}

- (NSDate *)getDateFromDateString:(NSString *)dateString
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

- (UIView*)didCreateDateView:(NSDictionary*)dict
{
    UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 247)];
    
    [commentView withBorder:@{@"Bcolor":[UIColor whiteColor],@"Bcorner":@(5),@"Bwidth":@(0)}];
    
    UIView* contentView = [[NSBundle mainBundle] loadNibNamed:@"EM_Menu" owner:self options:nil][3];
    
    contentView.frame = CGRectMake(0, 0, commentView.frame.size.width, commentView.frame.size.height);
    
    UIDatePicker * datePicker = ((UIDatePicker*)[self withView:contentView tag:11]);

    if([dict responseForKey:@"date"])
    {
        [datePicker setDate:[self getDateFromDateString:dict[@"date"]] animated:YES];
    }
    
    
    UISwitch * show = (UISwitch*)[self withView:contentView tag:18];
    
    [show setOn:[[dict getValueFromKey:@"show"] isEqualToString:@"1"]];

    
    DropButton * gender = (DropButton*)[self withView:contentView tag:12];
    
    NSArray * data = @[@{@"title":@"Nam", @"id":@"0"}, @{@"title":@"Nữ", @"id":@"1"}];
    
    __block NSString * genderId = @"0";
    
    if([dict responseForKey:@"gender"])
    {
        int numb = [dict[@"gender"] intValue];
        
        [gender setTitle:data[numb][@"title"] forState:UIControlStateNormal];
        
        genderId = dict[@"gender"];
    }
    
    [gender actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        [gender didDropDownWithData:@[@{@"title":@"Nam", @"id":@"0"}, @{@"title":@"Nữ", @"id":@"1"}] andCompletion:^(id object) {
            if(object)
            {
                [gender setTitle:object[@"data"][@"title"] forState:UIControlStateNormal];
                
                genderId = object[@"data"][@"id"];
            }
        }];
    }];
    
    [(UIButton*)[self withView:contentView tag:14] actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        
        [self close];
        
    }];
    
    [(UIButton*)[self withView:contentView tag:15] actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        
        if(self.menuCompletion)
        {            
            self.menuCompletion(0, @{@"date":[datePicker.date stringWithFormat:@"dd/MM/yyyy"], @"gender":genderId, @"show": show.isOn ? @"1" : @"0"}, self);
        }
        
        [self close];
    }];
    
    [commentView addSubview:contentView];
    
    return commentView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if(self.menuCompletion)
        self.menuCompletion(9000, nil, self);
    return YES;
}

- (EM_MenuView*)showWithCompletion:(MenuCompletion)_completion
{
    menuCompletion = _completion;
    
    [self show];
    
    id tableView = [self withView:self tag:11];

    if([tableView isKindOfClass:[UITableView class]])
    {
        [self performSelector:@selector(didScroll:) withObject:tableView afterDelay:0.3];
    }
    
    return self;
}

- (void)didScroll:(UITableView*)tableView
{
//    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[extraInfo[@"active"] intValue] inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [tableView cellVisible];
}

- (void)close
{
    [super close];
    
    if(timer)
    {
        [timer invalidate];
        
        timer = nil;
    }
}

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView*)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return [years count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [years objectAtIndex:row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return dataList.count == 0 ? 60 : tableView.tag == 11 ? 60 : 60;
}

- (UITableViewCell*)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier: dataList.count == 0 ? @"E_Empty_Music" : @"presetCell"];
    
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"EM_Menu" owner:nil options:nil][2];
    }
    
    NSMutableDictionary * dict = dataList[indexPath.row];
    
    [(UILabel*)[self withView:cell tag:11] setText:dict[@"description"]];
    
    UIButton * button = (UIButton*)[self withView:cell tag:10];
    
    [button setImage:[UIImage imageNamed: [[dataList[indexPath.row] getValueFromKey:@"subscribed"] isEqualToString:@"1"] ? @"check_ac" : @"check_in"] forState: UIControlStateNormal];
    
    [button actionForTouch:@{} and:^(NSDictionary *touchInfo) {
//        self->dataList[indexPath.row][@"subscribed"] = [[self->dataList[indexPath.row] getValueFromKey:@"subscribed"] isEqualToString:@"1"] ? @"0" : @"1";
        [self resort:indexPath.row];
        
        if(self.menuCompletion)
            self.menuCompletion(100, @{@"data": self->dataList[indexPath.row]}, self);
                
        [_tableView reloadData];
    }];

    return cell;
}

- (void)resort:(int) indexing {
    for (NSMutableDictionary * dict in dataList) {
        if ([dataList indexOfObject:dict] == indexing) {
            dict[@"subscribed"] = @"1";
        } else {
            dict[@"subscribed"] = @"0";
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(dataList.count == 0)
    {
        [self close];
        
        return;
    }

    NSDictionary * dict = dataList[indexPath.row];

//    dataList[indexPath.row][@"subscribed"] = [[dataList[indexPath.row] getValueFromKey:@"subscribed"] isEqualToString:@"1"] ? @"0" : @"1";
            
    [self resort:indexPath.row];

    [tableView reloadData];
    
    if(self.menuCompletion)
        self.menuCompletion(100, @{@"data": self->dataList[indexPath.row]}, self);
    
    if(self.menuCompletion)
        self.menuCompletion(12, @{@"data": dict}, self);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataList.count == 0 ? 0 : dataList.count;
}

@end


@implementation NSMutableArray (Convenience)

- (void)moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    // Optional toIndex adjustment if you think toIndex refers to the position in the array before the move (as per Richard's comment)
    if (fromIndex < toIndex) {
        toIndex--; // Optional
    }
    
    id object = [self objectAtIndex:fromIndex];
    [self removeObjectAtIndex:fromIndex];
    [self insertObject:object atIndex:toIndex];
}

@end
