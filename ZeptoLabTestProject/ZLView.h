//
//  ZLView.h
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

@class ZLView;

// delegate protocol
@protocol ZLViewProtocol <NSObject>

- (void) didCreateFrameBuffer: (ZLView *) view;
- (void) drawContentInView: (ZLView *) view;

@end

@interface ZLView : UIView

- (void) startAnimation;
- (void) stopAnimation;

@property (nonatomic, weak) id <ZLViewProtocol> delegate;

@end
