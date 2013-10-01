//
//  ZLView.m
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ZLView.h"

@interface ZLView () {
    NSTimer * _animationTimer;
    EAGLContext * _context;
    GLuint _renderSurface, _displaySurface;
    GLint _width, _height;
}

@end

@implementation ZLView

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (void) draw {
//    glBindFramebufferOES(GL_FRAMEBUFFER_OES, _displaySurface);

    if (self.delegate) {
        [self.delegate drawContentInView: self];
    }
    
//    glBindRenderbuffer(GL_RENDERBUFFER_OES, _displaySurface);
    [_context presentRenderbuffer: GL_RENDERBUFFER_OES];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [EAGLContext setCurrentContext: _context];
    [self destroyFramebuffer];
    [self createFramebuffer];
    [self draw];
}

- (BOOL) createFramebuffer {

    glGenFramebuffersOES(1, &_displaySurface);
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, _displaySurface);

    glGenRenderbuffersOES(1, &_renderSurface);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, _renderSurface);

    [_context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable: (CAEAGLLayer * ) self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, _displaySurface);

    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &_width);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &_height);

    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);

    if (self.delegate) {
        [self.delegate didCreateFrameBuffer: self];
    }
    return YES;
}

- (void) destroyFramebuffer {
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
    glDeleteFramebuffersOES(1, &_displaySurface);
    _displaySurface = 0;
    glDeleteRenderbuffersOES(1, &_renderSurface);
    _renderSurface = 0;

}

- (void) startAnimation {
    _animationTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 / ZLconfig_animationFrameRate
                                                       target: self
                                                     selector: @selector(draw)
                                                     userInfo: nil
                                                      repeats: true];
}

- (void) stopAnimation {
    [_animationTimer invalidate];
    _animationTimer = nil;
}

#pragma mark Initialization

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder: aDecoder]) {
        CAEAGLLayer * layer = (CAEAGLLayer *)self.layer;
        layer.opaque = true;
        layer.drawableProperties = @{kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8,
                                     kEAGLDrawablePropertyRetainedBacking: @YES};
        _context = [[EAGLContext alloc] initWithAPI: kEAGLRenderingAPIOpenGLES1];
        if (![EAGLContext setCurrentContext: _context]) {
            return nil;
        }

    }
    return self;
}

@end
