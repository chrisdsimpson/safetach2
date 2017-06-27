/*
 * File Name:	ReportViewController.m
 *
 * Version      1.0.0
 *
 * Date:		06/15/2017
 *
 * Description:
 *   This is view controller class for the pdf report for the iOS Safetach2 project.
 *
 * Notes:
 *
 * Related Document:
 *
 * Code Tested With:
 *   1. Xcode 8.2.1
 *
 * Author:		Christopher D. Simpson
 *
 * Company:		Maxton Manufacturing Company
 *				1728 Orbit Way
 *				Minden, NV  89423
 *				www.maxtonvalve.com
 *
 * Copyright (c) 2017 Maxton Manufacturing Company
 * All rights reserved.
 * Claim of copyright does not imply waiver of other rights.
 *
 * NOTICE OF PROPRIETARY RIGHTS.
 *
 * This program is a confidential trade secret and the property of
 * Maxton Manufacturing Company. Use, examination, reproduction,
 * disassembly, decompiling, transfer and/or disclosure to others of all
 * or any part of this software program are strictly prohibited except by
 * express written agreement with Maxton Manufacturing Company.
 */


#import "ReportViewController.h"
#import "Constants.h"


//@synthesize PrintButton;

@interface ReportViewController ()

@end

@implementation ReportViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /* Create the report */
    [self GenerateReport];
    
    /* Display the report */
    [self LoadReport];
    
}


- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillDisappear:(BOOL)animated
{
    /* This will take us back to the main screen */
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)didTouchUp:(id)sender
{
    UIButton *button = sender;
    
    switch(button.tag)
    {
        case 1: /* Help button */
        
        break;
            
        case 2: /* Print button */
            [self PrintReport];
        break;
            
        case 3: /* Email button */
            [self EmailReport];
        break;
    }
}

-(void) LoadReport
{
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:REPORT_FILE_NAME];
    
    NSURL *targetURL = [NSURL fileURLWithPath:pdfFileName];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [self.WebView loadRequest:request];
}


-(void) GenerateReport
{
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:REPORT_FILE_NAME];
    
    /* Loop through the ride data files for the report detail */
    for(NSString *filename in self.ReportFiles)
    {
        
    }
    
    
    NSString* textToDraw = @"                Safetach2 Report";
    CFStringRef stringRef = (__bridge CFStringRef)textToDraw;
    
    // Prepare the text using a Core Text Framesetter.
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    
    CGRect frameRect = CGRectMake(0, 0, 300, 50);
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);
    
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
    
    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, 100);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    CFRelease(frameRef);
    CFRelease(stringRef);
    CFRelease(framesetter);
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
    
}


- (void) PrintReport
{
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:REPORT_FILE_NAME];
    
    NSURL *targetURL = [NSURL fileURLWithPath:pdfFileName];
    
    UIPrintInteractionController *pc = [UIPrintInteractionController sharedPrintController];
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.orientation = UIPrintInfoOrientationPortrait;
    printInfo.jobName =@"Safetach2 Report";
    
    pc.printInfo = printInfo;
    //pc.showsPageRange = YES;
    pc.printingItem = targetURL;
    //pc.printingItem = [NSURL fileURLWithPath:[self returnFilePath]];
    
    UIPrintInteractionCompletionHandler completionHandler = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error)
    {
        if(!completed && error)
        {
            NSLog(@"Log - Print failed - domain: %@ error code %ld", error.domain, (long)error.code);
        }
    };
    
    [pc presentAnimated:YES completionHandler:completionHandler];
    
}


-(void) EmailReport
{
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:REPORT_FILE_NAME];
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    picker.mailComposeDelegate = self;
    [picker setSubject:@"Safetach2 Report"];
    NSData *pdfData = [NSData dataWithContentsOfFile:pdfFileName];
    [picker addAttachmentData:pdfData mimeType:@"application/pdf" fileName:REPORT_FILE_NAME];
    //[picker setMessageBody:@"Safetach2 report PDF file." isHTML:YES];
    
    [self presentModalViewController:picker animated:YES];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissModalViewControllerAnimated:YES];
    
    if (result==MessageComposeResultSent)
    {
        NSLog(@"Log - Email PDF sent");
    }
    else
    {
        NSLog(@"Log - Email PDF send error %@",error);
    }
}

@end
