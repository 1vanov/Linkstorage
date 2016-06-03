//
//  LSAttributedLabel.h
//  Linkstorage
//
//  Created by Ilya on 13.02.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import <TTTAttributedLabel/TTTAttributedLabel.h>

@interface LSAttributedLabel : NSObject

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url;

@end
