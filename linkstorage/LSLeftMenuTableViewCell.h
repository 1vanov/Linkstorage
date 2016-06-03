//
//  LSLeftMenuTableViewCell.h
//  Linkstorage
//
//  Created by Ilya on 25.02.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSLeftMenuTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *rightDetail;

- (id)initWithData:(NSArray *)data;

@end
