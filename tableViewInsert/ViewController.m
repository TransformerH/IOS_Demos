//
//  ViewController.m
//  tableViewInsert
//
//  Created by 韩雪滢 on 12/19/16.
//  Copyright © 2016 韩雪滢. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,strong) NSMutableArray *tryforit;
@property (nonatomic,strong) UITableView *nameTable;
@property (weak, nonatomic) IBOutlet UITextField *insertTable;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tryforit =[[NSMutableArray alloc] init];
    
    self.nameTable = (id)[self.view viewWithTag:1];
    UIEdgeInsets contentInset = self.nameTable.contentInset;
    contentInset.top = 20;
    [self.nameTable setContentInset:contentInset];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//--------------------  table delegate function

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tryforit count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableID = @"NameTableID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableID];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableID];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.contentMode = UIViewContentModeScaleToFill;
        [deleteBtn setTitle:@"Delete" forState:UIControlStateNormal];
        [deleteBtn setTag:[indexPath row]];
        [deleteBtn addTarget:self action:@selector(deleteAdd:) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.backgroundColor = [UIColor blueColor];
        deleteBtn.frame = CGRectMake(300, 10, 60, 20);
        [cell.contentView addSubview:deleteBtn];
    }
    
    cell.textLabel.text = self.tryforit[indexPath.row];
    return cell;
}
- (IBAction)insertCell:(id)sender {
    NSString *insertString = self.insertTable.text;
    if(insertString.length > 0){
        [self.tryforit addObject:insertString];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.tryforit.count-1 inSection:0];
//        [self.nameTable beginUpdates];
//        [self.nameTable endUpdates];
        [self.nameTable insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        self.insertTable.text = @"";
    }
}

- (void)deleteAdd:(id)sender{
    if([self.tryforit count] <= 0){
        return;
    }
    NSInteger indexBtn = [sender tag];
    
    if(indexBtn >= [self.tryforit count]){
        [sender setTag:indexBtn-1];
    }
    
    [self.tryforit removeObjectAtIndex:[sender tag]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    [self.nameTable beginUpdates];
    [self.nameTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.nameTable endUpdates];
}

@end
