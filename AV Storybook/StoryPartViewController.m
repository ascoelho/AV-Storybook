//
//  StoryPartViewController.m
//  AV Storybook
//
//  Created by Anthony Coelho on 2016-05-21.
//  Copyright © 2016 Anthony Coelho. All rights reserved.
//

#import "StoryPartViewController.h"
@import Photos;
@import MediaPlayer;
@import AVFoundation;
@import AVKit;

@interface StoryPartViewController () <AVAudioPlayerDelegate, AVAudioRecorderDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic)AVAudioPlayer *player;
@property (nonatomic) AVAudioRecorder *recorder;
@property (nonatomic) AVAudioSession *session;
@property (nonatomic) NSURL *soundFileURL;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *micButton;

@end

@implementation StoryPartViewController

#pragma mark - View Controller Life Cycle

\
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnedFromBackgroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self photolibraryAuthorizationStatus];
    [self cameraAccessAuthorizationStatus];
    
    self.imageView.image = self.photo.image;
    self.soundFileURL = self.photo.soundFileURL;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    
    [self.imageView addGestureRecognizer:tap];
    
    
    self.session = [AVAudioSession sharedInstance];
    [self setupSoundFileURL];
    [self setupRecorder];
    
}

- (void)setupSoundFileURL {
    NSArray *pathComponents = @[ [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],[NSString stringWithFormat:@"sound%ld.m4a", (long)self.index] ];
    self.soundFileURL = [NSURL fileURLWithPathComponents:pathComponents];
}

- (void)setupRecorder {
    
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    settings[AVFormatIDKey] = @(kAudioFormatMPEG4AAC);
    settings[AVSampleRateKey] = @(44100.0);
    settings[AVNumberOfChannelsKey] = @(2);
    // prepare for recording
    NSError *error = nil;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:self.soundFileURL settings:settings error:&error];
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    //[self.recorder prepareToRecord];
}

- (void)returnedFromBackgroundNotification:(NSNotification *)notification {
    [self photolibraryAuthorizationStatus];
    [self cameraAccessAuthorizationStatus];
}

#pragma mark - Checking Photo Library Authorization

- (BOOL)photolibraryAuthorizationStatus {
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    switch (authStatus) {
        case PHAuthorizationStatusAuthorized:
            return YES;
        case PHAuthorizationStatusNotDetermined: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                [self photolibraryAuthorizationStatus];
            }];
        }
            return NO;
        case PHAuthorizationStatusDenied:
            // fires if the user denies system attempt to authorize photo library
            [self alertUserWithMessage:@"This App Requires PhotoLibary Access To Work."];
            return NO;
        case PHAuthorizationStatusRestricted:
            return NO;
    }
}

- (void)alertUserWithMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Authorization" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel Tapped");
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Camera Access Authorization

- (BOOL)cameraAccessAuthorizationStatus {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusAuthorized:
            NSLog(@"Camera authorized");
            return YES;
        case AVAuthorizationStatusRestricted:
            NSLog(@"Camera restricted");
            return NO;
        case AVAuthorizationStatusNotDetermined:
            NSLog(@"Camera status not determined");
            [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            return NO;
        case AVAuthorizationStatusDenied:
            NSLog(@"Camera status denied");
            [self alertUserWithMessage:@"This App Requires Authorization To Use Your Camera"];
            return NO;
    }
}


- (IBAction)cameraButtonTapped:(id)sender {
    
    [self alertWithMessage:@"Please chose a photo source"];

}

- (void)alertWithMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Photo Source" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cameraChosen];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self libraryChosen];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)libraryChosen {
    UIImagePickerControllerSourceType photoLibSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (![UIImagePickerController isSourceTypeAvailable:photoLibSourceType]) {
        return;
    }
    if (![self photolibraryAuthorizationStatus]) {
        return;
    }
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = photoLibSourceType;
    imagePickerController.delegate = self;
    imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:
                                        photoLibSourceType];
    [self presentViewController:imagePickerController animated:YES completion:^{

    }];
}

- (void)cameraChosen {
    
    UIImagePickerControllerSourceType cameraSourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable:cameraSourceType]) {
        return;
    }
    if (![self cameraAccessAuthorizationStatus]) {
        return;
    }
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = cameraSourceType;
    imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:
                                        cameraSourceType];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //NSLog(@"%@", info);
    [self dismissViewControllerAnimated:YES completion:^ {
        // handle image
        if ([info[UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
            UIImage *image = info[UIImagePickerControllerOriginalImage];
            
            
            [self.delegate setImage:image atIndex:self.index];
            [self.view reloadInputViews];
            self.imageView.image = image;
            
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"Was cancelled");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)micButtonTapped:(id)sender {
    
    UIBarButtonItem *item = (UIBarButtonItem *)sender;
    
    
    if (self.player.playing) {
        [self.player stop];
    }
    if (!self.recorder.recording) {
        NSError *error = nil;
        [self.session setActive:YES error:&error];
        [self.session setCategory:AVAudioSessionCategoryRecord error:nil];
        NSAssert(error == nil, @"%@", error.localizedDescription);
        [self.recorder record];
        item.title = @"Stop";
    } else {
        
        [self.recorder stop];
        self.soundFileURL = self.recorder.url;
        [self.delegate setSoundURL:self.soundFileURL atIndex:self.index];
        item.title = @"Record";
    }
    
}


- (void)imageTapped:(id)sender {

    if (self.recorder.isRecording) {
        return;
    }
    if (self.player.isPlaying) {
        [self.player stop];
        return;
    }
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.soundFileURL error:nil];
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    self.player.delegate = self;
    [self.player play];
    
}




@end
