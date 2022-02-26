##  LC-3-master-verilog


## 1. 编译顺序
   ![Image text](https://github.com/lslxcode/LC-3-master-verilog/blob/master/img/%E7%BC%96%E8%AF%91%E9%A1%BA%E5%BA%8F.png)  
      
## 2. 测试
      CPU仿真的testbench中，只有CLK和RESET。而CPU执行的指令应该提前放入到内存中（RAM）。
      这里使用了一个比较简单的方法去仿真CPU，但其实应该使用读取文本的方式对memory进行初始化处理，如 $readmemb 语句。
      
   ![Image text](https://github.com/lslxcode/LC-3-master-verilog/blob/master/img/%E6%B5%8B%E8%AF%95.png)

## 3. 仿真结果

   ![Image text](https://github.com/lslxcode/LC-3-master-verilog/blob/master/img/%E4%BB%BF%E7%9C%9F.png)
   
   代码中，已经对一些关键的信息进行了$display输出。可以看到此时要执行的是“ADD R3 R1 R2”的指令，即R1+R2的值赋予R3，而最终的结果是R3=11。
   在CURRENT_STATE=6（保存）的时候，reg_file中，DR=’b011 (‘d3),  DR_IN=’b1011 (’d11) 。这个结果与所需结果一致。
   
## 4. 改进

   ![Image text](https://github.com/lslxcode/LC-3-master-verilog/blob/master/img/%E6%94%B9%E8%BF%9B.png)
     
     本代码的JMP等PC地址跳转指令仍需要改进，通过仿真可以看见，最后CPU一直在循环JMP指令，其原因是PC模块的连线并没有连接正确。
     
   
