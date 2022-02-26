
module register_16(LD, DATA_IN, DATA_OUT);
    input         LD;
    input [15:0]  DATA_IN;
    output [15:0] DATA_OUT;
    
    reg [15:0]    DATA_OUT;

    always @(LD or DATA_IN)   
    begin: load
        if (LD == 1'b1)
            DATA_OUT <= DATA_IN;
        else 
            DATA_OUT <= DATA_OUT;
    end
   
endmodule

module register_16_tb;
    reg         LD;
    reg  [15:0] DATA_IN;
    wire [15:0] DATA_OUT;  

    register_16 U_register_16(LD, DATA_IN, DATA_OUT);

    initial begin
        $monitor("LD =%h, DATA_IN =%h,DATA_OUT =%h",LD,DATA_IN,DATA_OUT);
        #10 LD = 1; 
        #10 DATA_IN = 16'h1234;
        #10 LD = 0; 
        #10 DATA_IN = 16'h0000;
        #10 LD = 0;
        #10 DATA_IN = 16'h1111;
        #10 LD = 1;
    end
   
endmodule
