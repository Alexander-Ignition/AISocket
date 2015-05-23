//
//  DetailViewController.h
//  AISocket
//
//  Created by Александр Игнатьев on 23.05.15.
//  Copyright (c) 2015 Alexander Ignition. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

