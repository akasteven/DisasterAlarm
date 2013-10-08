//
//  PDFViewController.m
//  LeavesExamples
//
//  Created by Tom Brow on 4/19/10.
//  Copyright 2010 Tom Brow. All rights reserved.
//

#import "PDFViewController.h"
#import "Utilities.h"
#import "LeavesView.h"

@interface PDFViewController ()

@property (readonly) CGPDFDocumentRef pdf;

@end

@implementation PDFViewController

- (id)init {
    if (self = [super init]) {
		CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("3.pdf"), NULL, NULL);
		_pdf = CGPDFDocumentCreateWithURL(pdfURL);
		CFRelease(pdfURL);
  
        self.leavesView.backgroundRendering = YES;
        [self displayPageNumber:1];
    }
    return self;
}

- (void)dealloc {
	CGPDFDocumentRelease(_pdf);
}

- (void)displayPageNumber:(NSUInteger)pageNumber {
	self.navigationItem.title = [NSString stringWithFormat:
								 @"Page %u of %lu", 
								 pageNumber, 
								 CGPDFDocumentGetNumberOfPages(_pdf)];
}

#pragma mark LeavesViewDelegate

- (void)leavesView:(LeavesView *)leavesView willTurnToPageAtIndex:(NSUInteger)pageIndex {
	[self displayPageNumber:pageIndex + 1];
}

#pragma mark LeavesViewDataSource

- (NSUInteger)numberOfPagesInLeavesView:(LeavesView*)leavesView {
	return CGPDFDocumentGetNumberOfPages(_pdf);
}

- (void)renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx {
	CGPDFPageRef page = CGPDFDocumentGetPage(_pdf, index + 1);
	CGAffineTransform transform = aspectFit(CGPDFPageGetBoxRect(page, kCGPDFMediaBox),
											CGContextGetClipBoundingBox(ctx));
	CGContextConcatCTM(ctx, transform);
	CGContextDrawPDFPage(ctx, page);
}

@end
