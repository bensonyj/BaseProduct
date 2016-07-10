//
//  AutoSlideScrollView.m
//  AutoSlideScrollViewDemo
//
//  Created by Mike Chen on 14-1-23.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "AutoSlideScrollView.h"

#pragma mark - 自定义pagecontrol

@interface CustomerPageControl : UIPageControl
{
    UIImage *_activeImage;
    UIImage *_inactiveImage;
    NSArray *_usedToRetainOriginalSubview;
}

@property (nonatomic, assign) CGFloat kSpacing;

- (id)initWithFrame:(CGRect)frame currentImageName:(NSString *)current commonImageName:(NSString *)common;

@end

@implementation CustomerPageControl

@synthesize kSpacing=_kSpacing;

- (id)initWithFrame:(CGRect)frame currentImageName:(NSString *)current commonImageName:(NSString *)common
{
    self= [super initWithFrame:frame];
    if ([self respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)] && [self respondsToSelector:@selector(setPageIndicatorTintColor:)]) {
        [self setCurrentPageIndicatorTintColor:[UIColor clearColor]];
        [self setPageIndicatorTintColor:[UIColor clearColor]];
    }
    
    [self setBackgroundColor:[UIColor clearColor]];
    _activeImage = [UIImage imageNamed:current];
    _inactiveImage = [UIImage imageNamed:common];
    _kSpacing = 5.0f;
    //hold住原来pagecontroll的subview
    _usedToRetainOriginalSubview = [NSArray arrayWithArray:self.subviews];
    //    for (UIView *su in self.subviews) {
    //        [su removeFromSuperview];
    //    }
    self.contentMode = UIViewContentModeScaleAspectFill;//UIViewContentModeRedraw;
    return self;
}

-(void)dealloc
{
    //释放原来hold住的那些subview
    _usedToRetainOriginalSubview = nil;
    _activeImage = nil;
    _inactiveImage = nil;
}

- (void)updateDots
{
    for (int i = 0; i< [self.subviews count]; i++) {
        //        UIImageView* dot =[self.subviews objectAtIndex:i];
        UIImageView * dot = [self imageViewForSubview:[self.subviews objectAtIndex: i]];
        if (i == self.currentPage) {
            if ([dot respondsToSelector:@selector(setImage:)]) {
                dot.image = _activeImage;
                CGRect rect = dot.frame;
                rect.size.width = _activeImage.size.width;
                rect.size.height = 5;
                dot.frame = rect;
            }
        } else {
            if ([dot respondsToSelector:@selector(setImage:)]) {
                dot.image = _inactiveImage;
                CGRect rect = dot.frame;
                rect.size.width = 5;
                rect.size.height = 5;
                dot.frame = rect;
            }
        }
    }
}

- (UIImageView *)imageViewForSubview: (UIView *) view {
    UIImageView * dot = nil;
    if ([view isKindOfClass: [UIView class]]) {
        for (UIView* subview in view.subviews) {
            if ([subview isKindOfClass:[UIImageView class]]) {
                dot = (UIImageView *)subview;
                break;
            }
        }
        if (dot == nil) {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height)];
            [view addSubview:dot];
        }
    }else {
        dot = (UIImageView *) view;
    }
    
    return dot;
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    //    if ([[[UIDevice currentDevice]systemVersion]floatValue] <=6.0) {
    //        [self updateDots];
    //    }
    //    [self setNeedsDisplay];
    [self updateDots];
    
}
- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    [super setNumberOfPages:numberOfPages];
    //    if ([[[UIDevice currentDevice]systemVersion]floatValue] <=6.0) {
    //        [self updateDots];
    //    }
    //    [self setNeedsDisplay];
    
    [self updateDots];
}
//-(void)drawRect:(CGRect)iRect
//{
//    if (__IOS_7){//加个判断
//        int i;
//        CGRect rect;
//        UIImage *image;
//        iRect = self.bounds;
//
//        if (self.opaque) {
//            [self.backgroundColor set];
//            UIRectFill(iRect);
//        }
//
//        if (self.hidesForSinglePage && self.numberOfPages == 1) return;
//
//        rect.size.height = _activeImage.size.height;
//        rect.size.width = self.numberOfPages * _activeImage.size.width + (self.numberOfPages - 1) * _kSpacing;
//        rect.origin.x = floorf( ( iRect.size.width - rect.size.width ) / 2.0 );
//        rect.origin.y = floorf( ( iRect.size.height - rect.size.height ) / 2.0 );
//        rect.size.width = _activeImage.size.width;
//
//        for ( i = 0; i < self.numberOfPages; ++i ) {
//            image = i == self.currentPage ? _activeImage : _inactiveImage;
//            [image drawInRect: rect];
//            rect.origin.x += _activeImage.size.width + _kSpacing;
//        }
//    }else {
//
//    }
//}

@end

#pragma mark - 定时器

@interface NSTimer (Addition)

- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end

@implementation NSTimer (Addition)

-(void)pauseTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}


-(void)resumeTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end

@interface AutoSlideScrollView () <UIScrollViewDelegate>
{
    CGFloat scrollViewStartContentOffsetX;
}
@property (nonatomic , assign) NSInteger currentPageIndex;
@property (nonatomic , assign) NSInteger totalPageCount;
@property (nonatomic , strong) NSMutableArray *contentViews;
@property (nonatomic , strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableDictionary *totalViews;

@property (nonatomic , strong) NSTimer *animationTimer;
@property (nonatomic , assign) NSTimeInterval animationDuration;

@property (nonatomic , strong) CustomerPageControl *pageControl;

@end

@implementation AutoSlideScrollView

- (CustomerPageControl *)pageControl
{
    //少于或者等于一页的话，没有必要显示pageControl
    if (self.totalPageCount > 1) {
        if (!_pageControl) {
            NSInteger totalPageCounts = self.totalPageCount;
            CGRect pageControlFrame = self.pageControlFrame;
            _pageControl =[[CustomerPageControl alloc] initWithFrame:pageControlFrame currentImageName:self.normalImageName commonImageName:self.abnormalImageName];
            _pageControl.numberOfPages = totalPageCounts;
            _pageControl.hidden = NO;
        }
    }
    return _pageControl;
}

- (void)setTotalPagesCount:(NSInteger (^)(void))totalPagesCount
{
    self.totalPageCount = totalPagesCount();
    if (self.totalPageCount > 0) {
        if (self.totalPageCount > 1) {
            self.scrollView.scrollEnabled = YES;
            self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
            [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
        } else {
            self.scrollView.scrollEnabled = NO;
        }
        //        [self configContentViews];
        [self addSubview:self.pageControl];
    }
}

- (void)setFetchContentViewAtIndex:(UIView *(^)(NSInteger index))fetchContentViewAtIndex
{
    _fetchContentViewAtIndex = fetchContentViewAtIndex;
    //加入第一页
    //    [self configContentViews];
    
    _currentPageIndex --;
    [self configContentViews];
    self.currentPageIndex = 0;
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex
{
    _currentPageIndex = currentPageIndex;
    [self.pageControl setCurrentPage:_currentPageIndex];
}

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration
{
    self = [self initWithFrame:frame];
    if (animationDuration > 0.0) {
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = animationDuration)
                                                               target:self
                                                             selector:@selector(animationTimerDidFired:)
                                                             userInfo:nil
                                                              repeats:YES];
        [self.animationTimer pauseTimer];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizesSubviews = YES;
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.autoresizingMask = 0xFF;
        self.scrollView.contentMode = UIViewContentModeCenter;
        self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        [self addSubview:self.scrollView];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.scrollsToTop = NO;
        self.currentPageIndex = 0;
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = 3)
                                                               target:self
                                                             selector:@selector(animationTimerDidFired:)
                                                             userInfo:nil
                                                              repeats:YES];
        [self.animationTimer pauseTimer];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizesSubviews = YES;
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.autoresizingMask = 0xFF;
        self.scrollView.contentMode = UIViewContentModeCenter;
        self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.scrollsToTop = NO;
        [self addSubview:self.scrollView];
        self.currentPageIndex = 0;
    }
    return self;
}

#pragma mark -
#pragma mark - 私有函数

- (void)configContentViews
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //    [self setScrollViewContentDataSource];
    //
    //    NSInteger counter = 0;
    //    for (UIView *contentView in self.contentViews) {
    //        contentView.userInteractionEnabled = YES;
    //        UILongPressGestureRecognizer *longTapGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapGestureAction:)];
    //        [contentView addGestureRecognizer:longTapGesture];
    //
    //        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
    //        [contentView addGestureRecognizer:tapGesture];
    //        CGRect rightRect = contentView.frame;
    //        rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (counter ++), 0);
    //
    //        contentView.frame = rightRect;
    //        [self.scrollView addSubview:contentView];
    //    }
    //    if (self.totalPageCount > 1) {
    //        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    //    }
    
    for (NSInteger i = 0; i < 3; i++) {
        UIView *content = [self contentViewForSection:[self getValidNextPageIndexWithPageIndex:_currentPageIndex+i]];
        CGRect rect = content.frame;
        rect.origin = CGPointMake(_scrollView.frame.size.width * i , 0);
        content.frame = rect;
        [self.scrollView addSubview:content];
    }
    if (self.totalPageCount > 1) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    }
}

//将views储存到字典中，防止多次调用
- (UIView *)contentViewForSection:(NSInteger)index{
    if (!_totalViews) {
        _totalViews = [NSMutableDictionary dictionaryWithCapacity:_totalPageCount];
    }
    NSNumber *indexNum = [NSNumber numberWithInteger:index];
    if (![_totalViews objectForKey:indexNum]) {
        UIView *content = self.fetchContentViewAtIndex(index);
        content.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [content addGestureRecognizer:tapGesture];
        [_totalViews setObject:content forKey:indexNum];
    }
    if (_totalPageCount < 3) {
        //小于三张图片时，复制UIView
        UIView *view = _totalViews[indexNum];
        NSData *tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
        UIView *copyView = [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [copyView addGestureRecognizer:tapGesture];
        
        if ([view isKindOfClass:[UIImageView class]] && [copyView isKindOfClass:[UIImageView class]]) {
            ((UIImageView *)copyView).image = [(UIImageView *)view image];
        }
        
        return copyView;
    }
    return _totalViews[indexNum];
}

/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource
{
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    
    if (self.fetchContentViewAtIndex) {
        id set = (self.totalPageCount == 1)?[NSSet setWithObjects:@(previousPageIndex),@(_currentPageIndex),@(rearPageIndex), nil]:@[@(previousPageIndex),@(_currentPageIndex),@(rearPageIndex)];
        for (NSNumber *tempNumber in set) {
            NSInteger tempIndex = [tempNumber integerValue];
            if ([self isValidArrayIndex:tempIndex]) {
                [self.contentViews addObject:self.fetchContentViewAtIndex(tempIndex)];
            }
        }
    }
}

- (BOOL)isValidArrayIndex:(NSInteger)index
{
    if (index >= 0 && index <= self.totalPageCount - 1) {
        return YES;
    } else {
        return NO;
    }
}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    //    if(currentPageIndex == -1) {
    //        return self.totalPageCount - 1;
    //    } else if (currentPageIndex == self.totalPageCount) {
    //        return 0;
    //    } else {
    //        return currentPageIndex;
    //    }
    
    return (_totalPageCount + currentPageIndex) % _totalPageCount;
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    scrollViewStartContentOffsetX = scrollView.contentOffset.x;
    [self.animationTimer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    //    if (self.totalPageCount == 2) {
    //        if (scrollViewStartContentOffsetX < contentOffsetX) {
    //            UIView *tempView = (UIView *)[self.contentViews lastObject];
    //            tempView.frame = (CGRect){{2 * CGRectGetWidth(scrollView.frame),0},tempView.frame.size};
    //        } else if (scrollViewStartContentOffsetX > contentOffsetX) {
    //            UIView *tempView = (UIView *)[self.contentViews firstObject];
    //            tempView.frame = (CGRect){{0,0},tempView.frame.size};
    //        }
    //    }
    //
    //    if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
    //        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    //        //        NSLog(@"next，当前页:%d",self.currentPageIndex);
    //        [self configContentViews];
    //    }
    //    if(contentOffsetX <= 0) {
    //        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    //        //        NSLog(@"previous，当前页:%d",self.currentPageIndex);
    //        [self configContentViews];
    //    }
    
    if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        [self configContentViews];
        
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    }
    if(contentOffsetX <= 0) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 2];
        [self configContentViews];
        
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}

#pragma mark -
#pragma mark - 响应事件

- (void)longTapGestureAction:(UILongPressGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateBegan) {
        //        NSLog(@"UIGestureRecognizerStateBegan");
        [self.animationTimer pauseTimer];
    }
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        [self.animationTimer resumeTimer];
        //        NSLog(@"UIGestureRecognizerStateEnded");
    }
}

- (void)animationTimerDidFired:(NSTimer *)timer
{
    CGFloat space = 0;
    if (((long)self.scrollView.contentOffset.x % (long)SCREEN_WIDTH ) > 1) {
        //        space = ceil(self.scrollView.contentOffset.x / SCREEN_WIDTH) * SCREEN_WIDTH + self.scrollView.contentOffset.x - ((long)self.scrollView.contentOffset.x % (long)SCREEN_WIDTH);
        
        space = self.scrollView.contentOffset.x - ((long)self.scrollView.contentOffset.x % (long)SCREEN_WIDTH);
    }else{
        space = self.scrollView.contentOffset.x;
    }
    
    //    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    CGPoint newOffset = CGPointMake(space + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{
    if (self.TapActionBlock) {
        self.TapActionBlock(self.currentPageIndex);
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
