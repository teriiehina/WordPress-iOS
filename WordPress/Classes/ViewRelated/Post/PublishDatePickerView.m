#import "PublishDatePickerView.h"

@implementation PublishDatePickerView

- (NSArray *)buttonsForToolbar
{
    NSMutableArray *arr = [[super buttonsForToolbar] mutableCopy];

    NSString *title = NSLocalizedString(@"Publish Immediately", @"Post publishing status in the Post Editor/Settings area (compare with WP core translations).");
    UIBarButtonItem *publishButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(publishImmediately)];
    arr[0] = publishButton;

    return arr;
}

- (void)publishImmediately
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:didFinishWithValue:)]) {
        [self.delegate pickerView:self didFinishWithValue:nil];
    }
}

@end
