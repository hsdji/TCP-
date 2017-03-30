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
@interface ViewController ()

@end

@implementation ViewController
//根据流程图  做一个客户端-----》实现可以和服务器数据交互
- (void)viewDidLoad {
    [super viewDidLoad];
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
    int client = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
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
    seriviceAddr.sin_addr.s_addr = inet_addr("127.0.0.1");//这里强制转换成inet_addr类型192.168.1.1
//  参数三  传入地址的长度
    int result = connect(client,(const  struct sockaddr *)&seriviceAddr, sizeof(seriviceAddr));
    
    if (result == 0){
//        代表连接成功   在服务器开启端口   让客户端连接
        NSLog(@"连接成功");
//        接下来  是不是就开始进行通讯  发送数据
        NSString *message = @"hello word 中";
        /**
         *     @author xiaofei, 17-03-30 22:03:32
         *
         *     @brief 第一个参数  客户端的scoket
                      第二个参数  发送内容的一个指针地址
                      第三个参数  发送的内容的长度
                      第四个参数  指的是发送的标示  一般赋值0
         message  是一个什么类型的变量  OC类型的  但是我们的socket是基于C开发的
         */
          ssize_t sendL=  send(client, message.UTF8String, strlen(message.UTF8String), 0);
        NSLog(@"你发送了%zd个字符",sendL);
//        服务器,返回给客户端消息1.客户端的socket 2.返回内容 3.长度 4. 标示
        //接受过来的数据------>做缓存处理
        //  接受的数据  和发送的数据  最后转化成一致
        // buffer  缓存
        while (1)
        {
            
        
        uint8_t buffer[1024];
       ssize_t recvLength = recv(client, buffer, sizeof(buffer), 0);//C++
        NSLog(@"你接受了%zd个字符",recvLength);
//        处理服务器返回的数据
//        可以看作一个数据解析的过程
        NSData *data = [NSData dataWithBytes:buffer length:recvLength];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"这个数据是\n %@",str);
            }
//        打印完了以后没有进行处理  至进行了一次数据传输
//        关闭socket
//         close(client);
        
        

        
    }else{
//    代表失败
        NSLog(@"连接失败%d",result);
        return;
    }
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
