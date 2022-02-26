////////////////////////////////////////////////////////// 
//               register_file function:                //
//                                                      //
// LD=0: read:  1.select Register(R0-R7) by SRx         //
//              2.output the Rn to SRx_OUT              //
//                                                      //
// LD=1: write: 1.select Register(R0-R7) by DR          //
//              2.write DR_IN into Rn                   //
////////////////////////////////////////////////////////// 

module register_file(LD, DR, SR1, SR2, DR_IN, SR1_OUT, SR2_OUT);
    input         LD;
    input [2:0]   DR;
    input [2:0]   SR1;
    input [2:0]   SR2;
    input [15:0]  DR_IN;
    output [15:0] SR1_OUT;
    output [15:0] SR2_OUT;
    
    wire          R0_LD;
    wire          R1_LD;
    wire          R2_LD;
    wire          R3_LD;
    wire          R4_LD;
    wire          R5_LD;
    wire          R6_LD;
    wire          R7_LD;
    wire          SR1_LD;
    wire          SR2_LD;
    
    wire [15:0]   R0_OUT;
    wire [15:0]   R1_OUT;
    wire [15:0]   R2_OUT;
    wire [15:0]   R3_OUT;
    wire [15:0]   R4_OUT;
    wire [15:0]   R5_OUT;
    wire [15:0]   R6_OUT;
    wire [15:0]   R7_OUT;
    
    wire [15:0]   SR1_IN;
    wire [15:0]   SR2_IN;
    
    wire [7:0]    DEC_LD;

    // write : 1.select Register(R0-R7) by DR
    decoder_3to8 comp_ld(.D_IN(DR), .D_OUT(DEC_LD));   

    assign R0_LD = DEC_LD[0] & LD;
    assign R1_LD = DEC_LD[1] & LD;
    assign R2_LD = DEC_LD[2] & LD;
    assign R3_LD = DEC_LD[3] & LD;
    assign R4_LD = DEC_LD[4] & LD;
    assign R5_LD = DEC_LD[5] & LD;
    assign R6_LD = DEC_LD[6] & LD;
    assign R7_LD = DEC_LD[7] & LD;

    // write : 2.write DR_IN into Rn
    register_16 R0(.LD(R0_LD), .DATA_IN(DR_IN), .DATA_OUT(R0_OUT));  
    register_16 R1(.LD(R1_LD), .DATA_IN(DR_IN), .DATA_OUT(R1_OUT));  
    register_16 R2(.LD(R2_LD), .DATA_IN(DR_IN), .DATA_OUT(R2_OUT));  
    register_16 R3(.LD(R3_LD), .DATA_IN(DR_IN), .DATA_OUT(R3_OUT));  
    register_16 R4(.LD(R4_LD), .DATA_IN(DR_IN), .DATA_OUT(R4_OUT));  
    register_16 R5(.LD(R5_LD), .DATA_IN(DR_IN), .DATA_OUT(R5_OUT));  
    register_16 R6(.LD(R6_LD), .DATA_IN(DR_IN), .DATA_OUT(R6_OUT)); 
    register_16 R7(.LD(R7_LD), .DATA_IN(DR_IN), .DATA_OUT(R7_OUT)); 

    // read : 1.select Register(R0-R7) by SRx
    mux16_8to1 ChoseSR1( .SEL(SR1),      .D_IN0(R0_OUT), .D_IN1(R1_OUT), .D_IN2(R2_OUT), .D_IN3(R3_OUT),
                         .D_OUT(SR1_IN), .D_IN4(R4_OUT), .D_IN5(R5_OUT), .D_IN6(R6_OUT), .D_IN7(R7_OUT));
    
    mux16_8to1 ChoseSR2( .SEL(SR2),      .D_IN0(R0_OUT), .D_IN1(R1_OUT), .D_IN2(R2_OUT), .D_IN3(R3_OUT),
                         .D_OUT(SR2_IN), .D_IN4(R4_OUT), .D_IN5(R5_OUT), .D_IN6(R6_OUT), .D_IN7(R7_OUT)); 

    // read : 2.output the Rn to SRx_OUT 
    assign SR1_LD = (~LD);
    assign SR2_LD = (~LD); 

    register_16 SR1_REG(.LD(SR1_LD), .DATA_IN(SR1_IN), .DATA_OUT(SR1_OUT)); 
    register_16 SR2_REG(.LD(SR2_LD), .DATA_IN(SR2_IN), .DATA_OUT(SR2_OUT));

    // display message for test
    always @(LD) begin
        if(SR1_LD) $display("%m:At time %0t: SR1_LD= %b , SR1= %b, SR1_OUT= %b",$time,SR1_LD,SR1,SR1_OUT);
        if(SR2_LD) $display("%m:At time %0t: SR2_LD= %b , SR2= %b, SR2_OUT= %b",$time,SR2_LD,SR1,SR2_OUT);
        if(   LD ) $display("%m:At time %0t: LD= %b , DR= %b, DR_IN= %b",$time,LD,DR,DR_IN);
    end

endmodule



module register_file_tb ;
    reg         LD;
    reg [2:0]   DR;
    reg [2:0]   SR1;
    reg [2:0]   SR2;
    reg [15:0]  DR_IN;
    wire [15:0] SR1_OUT;
    wire [15:0] SR2_OUT;

    reg[3:0] i;

    register_file U_register_file(LD, DR, SR1, SR2, DR_IN, SR1_OUT, SR2_OUT);

    initial begin
        $monitor("LD = %h, DR = %h, SR1 = %h, SR2 = %h, DR_IN = %h, SR1_OUT = %h, SR2_OUT = %h",LD, DR, SR1, SR2, DR_IN, SR1_OUT, SR2_OUT);
        LD = 1;
        for ( i = 0 ; i< 8 ; i=i+1 ) begin
            $display("write:");
            DR = i ;
            DR_IN = i;
            LD = 1 ;
            #10 

            $display("read:");
            SR1 = i;
            SR2 = i-1;
            LD = 0 ;
            #10;

            DR_IN = i+8;
            #10;
        end
        $display("random test:");
        for ( i = 0 ; i< 8 ; i=i+1 ) begin
            $display("write:");
            DR = {$random}%8 ;
            DR_IN = {$random}%(1<<16);
            LD = 1 ;
            #10 
            
            $display("read:");
            SR1 = {$random}%8;
            SR2 = {$random}%8;
            LD = 0 ;
            #10;
        end
    end
endmodule

// module register_file_tb;

//     //给DUT灌入的激励
//     reg             LD;
//     reg   [2:0]     DR;
//     reg   [2:0]     SR1;
//     reg   [2:0]     SR2;
//     reg   [15:0]    DR_IN;
//     wire  [15:0]    SR1_OUT;
//     wire  [15:0]    SR2_OUT;

//     //得到DUT理想值所需要的的变量，用来和例化的DUT对比
//     reg   [15:0]    reg_f[0:7];  
//     reg   [15:0]    expect1;
//     reg   [15:0]    expect2;
//     //random随机化所用的seed种子
//     reg   [7:0]     sd;

//     register_file reg_file(
//         .LD(LD),
//         .DR(DR),
//         .SR1(SR1),
//         .SR2(SR2),
//         .DR_IN(DR_IN),
//         .SR1_OUT(SR1_OUT),
//         .SR2_OUT(SR2_OUT)
//     );
    
//     initial begin
//        //将理想对照组的寄存器也初始化为0
//             reg_f[0]=0;
//             reg_f[1]=0;
//             reg_f[2]=0;
//             reg_f[3]=0;
//             reg_f[4]=0;
//             reg_f[5]=0;
//             reg_f[6]=0;
//             reg_f[7]=0;
//         //将DUT里面的寄存器值初始化位为0
//             LD=1;
//             SR1=0;
//             SR2=0;
//             DR_IN=0;
//             DR=0;
//             #1 DR=DR+1;
//             #1 DR=DR+1;
//             #1 DR=DR+1;
//             #1 DR=DR+1;
//             #1 DR=DR+1;
//             #1 DR=DR+1;
//             #1 DR=DR+1;  
//             #1 LD=0;     
//     end

//      //verify response ：计算理想数值，并将其和DUT数值进行对比验证，进行报错
//     task reference;
//         //DUT的输入
//         input [2:0]   SR1;
//         input [2:0]   SR2;
//         //DUT的输出
//         input [15:0] SR1_OUT;
//         input [15:0] SR2_OUT;
//         //计算并存放理想数值的变量
//         input [15:0]  expect1;
//         input [15:0]  expect2;
       
//         begin
//             //part2 对比DUT的实际输出 和 期待的情况
//             if( SR1_OUT!==expect1 && LD==0)
//                 begin
//                     $display("READ1 FALIED!!!");
//                     $display("At time %0t and REG-FIEL-adress %h : the read-value of is %h and should be %h",$time,SR1,SR1_OUT,expect1);
//                 end
//             if ( SR2_OUT!==expect2 && LD==0) 
//                 begin
//                     $display("READ2 FALIED!!!");
//                     $display("At time %0t and REG-FIEL-adress %h : the read-value of is %h and should be %h",$time,SR2,SR2_OUT,expect2); 
//                 end 
                
//         end
//     endtask

//     //Apply stimulus：加入随机化的testcase
//     initial
//         begin
//             //利用系统函数$get_initial_random_seed获得 randomd使用需要的种子
//             sd=0;//$get_initial_random_seed();    
//             #8
//             repeat(50)              //获得20组随机输入
//                 begin
//                     #1//每2ns更新一次随机输入
//                     LD={$random(sd)%2}; 
//                     DR=DR+{$random(sd)%4};
//                     //每执行一次$random(seed)产生一个随机数，seed也自动更新一次。
//                     SR1=SR1+{$random(sd)%4};
//                     SR2=SR2+{$random(sd)%4};
//                     DR_IN={$random(sd)%17'h10000};
//                     //等待DUT结果出来
//                     //计算理想情况下的情况
//                     if(LD)  begin
//                             reg_f[DR]=DR_IN;
//                     end
//                     expect1=reg_f[SR1];
//                     expect2=reg_f[SR2];
//                     reference(SR1,SR2,SR1_OUT,SR2_OUT,expect1,expect2);    
//                 end
//             $display("TEST FINISH!");
//             $finish;
//         end
// endmodule
