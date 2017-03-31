//
//  ViewController.m
//  scoket_客户端
//
//  Created by 小飞 on 17/3/30.
//  Copyright © 2017年 小飞. All rights reserved.
//
/**
 *     @author xiaofei, 17-03-30 22:03:15
 *
 *     @brief TCP长连接
 *
 *     @param void 使用之前  打开电脑的4321端口   命令行nc -lk 4321
 *
 *     @return 运行程序   看你dubug输出窗口   和dos命令窗口  的输出
 */
#import "ViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import "CuuTableViewCell.h"
#import "CustomerTableViewCell.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    int client;
    UITableView *tabView;
    UITextField *textfled;
    BOOL isMy;
    NSString *test;
    NSMutableArray <NSDictionary *>*messageArrr;
}
@end

@implementation ViewController
//根据流程图  做一个客户端-----》实现可以和服务器数据交互
- (void)viewDidLoad {
    [super viewDidLoad];
    isMy = YES;
    
    tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 66, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    
     [tabView registerClass:[CuuTableViewCell class] forCellReuseIdentifier:@"my"];
     [tabView registerClass:[CustomerTableViewCell class] forCellReuseIdentifier:@"you"];
     tabView.tableFooterView = [UIView new];
}

-(void)send{
    [self.view endEditing:YES];
    ssize_t sendL=  send(client, textfled.text.UTF8String, strlen(textfled.text.UTF8String), 0);
    test = textfled.text;
    NSLog(@"你发送了%zd个字符",sendL);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:textfled.text,@"message",@"0",@"formMe",nil];
    [messageArrr addObject:dic];
    [tabView reloadData];
    textfled.text = @"";
}


-(void)viewWillAppear:(BOOL)animated
{
    textfled = [[UITextField alloc] initWithFrame:CGRectMake(5, 20, [UIScreen mainScreen].bounds.size.width-80, 44)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textfled];
    textfled.delegate = self;
    textfled.layer.borderWidth = 2.0f;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-80, 20, 80, 44)];
    [btn setTitle:@"发送"forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    tabView.delegate = self;
    tabView.dataSource = self;
    [self.view addSubview:tabView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messageArrr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ss = [messageArrr[indexPath.row] valueForKey:@"message"];
    
    CGFloat unm =  [self measureMutilineStringHeight:ss andFont:[UIFont systemFontOfSize:17] andWidthSetup:0.8*self.view.frame.size.width];
    if (unm/44 > 0)
    {
        return 44*(NSInteger)unm/44+44;
    }else
    return 44;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *aa = [messageArrr[indexPath.row] valueForKey:@"formMe"];
    
    if ([aa isEqualToString:@"1"])
    {
        CustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"you"];
        if (cell == nil)
        {
        
        cell = [[CustomerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"you"];
    }
        cell.backgroundColor = [UIColor lightGrayColor];
        cell.textLabel.text = [messageArrr[indexPath.row] valueForKey:@"message"];
        return cell;
    }else{
         CuuTableViewCell *Cuucell = [tableView dequeueReusableCellWithIdentifier:@"my"];
        if (Cuucell == nil)
        {
            
       Cuucell = [[CuuTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"my"];//
        }
        Cuucell.backgroundColor = [UIColor blueColor];
        Cuucell.message.text = [messageArrr[indexPath.row] valueForKey:@"message"];
        return Cuucell;
    }
}






-(void)viewDidAppear:(BOOL)animated
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initClick];
    });
}


-(void)initClick{
    //    scoket－－－－－》不只是针对iOS
    //    socket------->iOS  安卓   C++  之类的设计到即时通讯都是这个C库
    //    这里的传的3个int是什么
    /**
     *     @author xiaofei, 17-03-30 21:03:28
     *
     *     @brief 建立socket对象
     *
     *     @param int  传输协议
     *     @param int  类型 SOCK_STREAM  string也叫做  流   值得是TCP数据流
     SOCK_DGRAM   UDP协议
     *     @param int  协议（明确的指定用什么协议传输）
     *
     *     @return 返回int  返回 正数代表  socket创建成功
     */
    //    3367353336  老师    助理:865300001  lina 1900006359
    //    建立sockrt
    client = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    //   第二不 和服务器进行连接
    /**
     *     @author xiaofei, 17-03-30 21:03:52
     *
     *     @brief 开始连接
     *
     *     @param int     客户端的socket
     *     @param int      结构体  addr  是scoket地址的指针  结构体指针地址
     *     @param socklen_t 地址的长度
     *
     *     @return 返回值  返回类型 还是int  返回一个正数代表连接失败  返回的正数代表错误代码  错误码
     */
    
    //    新建第二个参数
    struct sockaddr_in seriviceAddr;
    seriviceAddr.sin_family = AF_INET;//协议
    seriviceAddr.sin_port = htons(4321);//端口号
    //这里将本机直接作为服务器进行测试（127.0.0.1）
    seriviceAddr.sin_addr.s_addr = inet_addr("192.168.43.24");//这里强制转换成inet_addr类型192.168.1.1
    //  参数三  传入地址的长度
    int result = connect(client,(const  struct sockaddr *)&seriviceAddr, sizeof(seriviceAddr));
    
    if (result == 0){
        //        代表连接成功   在服务器开启端口   让客户端连接
        NSLog(@"连接成功");
        //        接下来  是不是就开始进行通讯  发送数据
        NSString *message = @"您好,很高兴为您服务.......";
        /**
         *     @author xiaofei, 17-03-30 22:03:32
         *
         *     @brief 第一个参数  客户端的scoket
         第二个参数  发送内容的一个指针地址
         第三个参数  发送的内容的长度
         第四个参数  指的是发送的标示  一般赋值0
         message  是一个什么类型的变量  OC类型的  但是我们的socket是基于C开发的
         */
        //        服务器,返回给客户端消息1.客户端的socket 2.返回内容 3.长度 4. 标示
        //接受过来的数据------>做缓存处理
        //  接受的数据  和发送的数据  最后转化成一致
        // buffer  缓存
        test = message;
        send(client, message.UTF8String, strlen(message.UTF8String), 0);
        messageArrr = [[NSMutableArray alloc]init];
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:message,@"message",@"1",@"formMe", nil];
        [messageArrr addObject:dic];
        dispatch_async(dispatch_get_main_queue(), ^{
           [tabView reloadData];
        });
        while (1)
        {
            uint8_t buffer[1024];
            ssize_t recvLength = recv(client, buffer, sizeof(buffer), 0);//C++
            NSLog(@"你接受了%zd个字符",recvLength);
            NSData *data = [NSData dataWithBytes:buffer length:recvLength];
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"这个数据是\n %@",str);
            test = str;
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:str,@"message",@"1",@"formMe" ,nil];
            [messageArrr addObject:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                  [tabView reloadData];
            });
        }
        //        打印完了以后没有进行处理  至进行了一次数据传输
        //        关闭socket
        close(client);
    }else{
        //    代表失败
        NSLog(@"连接失败%d",result);
        return;
    }
}


-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str = [textfled.text stringByAppendingString:string];
    
    CGFloat height = [self measureMutilineStringHeight:str andFont:[UIFont systemFontOfSize:17] andWidthSetup:[UIScreen mainScreen].bounds.size.width-80];
     CGRect rect = textfled.frame;
    if (height/rect.size.height>1) {

    }
    rect.size.height = height;
    textfled.frame = rect;
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textfled.frame = CGRectMake(5, 20, [UIScreen mainScreen].bounds.size.width-80, 44);
}





- (float)measureMutilineStringHeight:(NSString*)str andFont:(UIFont*)wordFont andWidthSetup:(float)width
{
    if (str == nil || width <= 0) return 0;
    
    CGSize measureSize;
    
    if([[UIDevice currentDevice].systemVersion floatValue] < 7.0){
        
        measureSize = [str sizeWithFont:wordFont constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        
    }else{
        
        measureSize = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:wordFont, NSFontAttributeName, nil] context:nil].size;
        
    }
    
    return ceil(measureSize.height);
    
}

@end
