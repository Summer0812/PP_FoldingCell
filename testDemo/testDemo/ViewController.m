//
//  ViewController.m
//  testDemo
//
//  Created by Imac 21 on 16/1/6.
//  Copyright © 2016年 Imac 21. All rights reserved.
//

#import "ViewController.h"

#import "foldTableViewCell.h"
#import "secondViewController.h"
#import "DSLTransitionFromSecondToFirst.h"
#import "DSLTransitionFromFirstToSecond.h"


static const CGFloat kCloseCellHeight  = 179;
static const CGFloat kOpenCellHeight = 488;
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
{
    NSMutableArray *heightArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    // Do any additional setup after loading the view, typically from a nib.
    self.testTableView.delegate=self;
    self.testTableView.dataSource=self;
    [self.testTableView registerNib:[UINib nibWithNibName:NSStringFromClass([foldTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    heightArray=[NSMutableArray array];

    for (int i=0; i<10; i++) {
        [heightArray addObject:[NSNumber numberWithFloat:kCloseCellHeight]];
    }
    NSLog(@"viewDidLoad－－－－－－－－－－－delay");

    [self.testTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberRows");

    return 10;
}

-(foldTableViewCell *)tableViewCellForThing:(NSIndexPath *)indexPath
{

    if (indexPath.row== NSNotFound) {
        return nil;
    }
    
    return (foldTableViewCell*)[self.testTableView cellForRowAtIndexPath:indexPath];

}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return [heightArray[indexPath.row] floatValue];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    foldTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if ([heightArray[indexPath.row] floatValue]==kCloseCellHeight) {
        
        [cell selectedAnimation:NO animated:NO completion:nil];
    }else
    {
        [cell selectedAnimation:YES animated:NO completion:nil];

    }
//    [cell selectedAnimation:NO animated:NO];
    
    [cell fold_imageTap:^{
        secondViewController *secVC=[[secondViewController alloc]initWithNibName:@"secondViewController" bundle:nil];
        secVC.cellIndex=indexPath;
        self.navigationController.delegate=self;
        [self.navigationController pushViewController:secVC animated:YES];
    }];
    NSLog(@"celll");
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    foldTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if([cell isAnimating]) return;
    
    
    CGFloat durtion=0.0;
    if([heightArray[indexPath.row] floatValue]==kCloseCellHeight)
    {
        [heightArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithFloat:kOpenCellHeight]];
        durtion=0.3;
        [cell selectedAnimation:YES animated:YES completion:^{
            
            NSLog(@"完成了");
            
        }];

    }else
    {
        durtion=[cell returnSumTime];
        [heightArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithFloat:kCloseCellHeight]];
        [cell selectedAnimation:NO animated:YES completion:^{
        
    }];
   
}
    [UIView animateWithDuration:durtion+0.3 animations:^{
        [self.testTableView beginUpdates];
        [self.testTableView endUpdates];
    }];
 
    
}


-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    
    return [[DSLTransitionFromFirstToSecond alloc]init];
}
//-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
//{
//    return self.interactivePopTransition;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
