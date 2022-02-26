
module pc(CLK, RESET,LD, PCSEL, OFFSET, DIRECT, PC_OUT);
    input         CLK;
    input         RESET;
    input         LD;
    input [1:0]   PCSEL;
    input [15:0]  OFFSET;
    input [15:0]  DIRECT;
    output [15:0] PC_OUT;
    
    
    wire [15:0]   PC_REG_IN;
    reg [15:0]    PC_REG_OUT;
    wire [15:0]   PLUS_ONE;
    
    
    mux16_4to1 pc_mux(.SEL(PCSEL), .D_IN0(PLUS_ONE), .D_IN1(OFFSET), .D_IN2(DIRECT), .D_IN3(), .D_OUT(PC_REG_IN));
    
    
    always @(posedge CLK)
    begin: pc_reg
        if (RESET) PC_REG_OUT<=0;
        else if ( LD == 1'b1)
            PC_REG_OUT <= PC_REG_IN;
        else 
            PC_REG_OUT <= PC_REG_OUT;
    end
    
    
    inc1 pc_inc(.D_IN(PC_REG_OUT), .D_OUT(PLUS_ONE));
    
    assign PC_OUT = PC_REG_OUT;
    
endmodule

module pc_tb;
    reg          CLK;
    reg          RESET;
    reg          LD;
    reg  [1:0]   PCSEL;
    reg  [15:0]  OFFSET;
    reg  [15:0]  DIRECT;
    wire [15:0] PC_OUT;

    reg [3:0]i;

    pc U_pc(CLK, RESET,LD, PCSEL, OFFSET, DIRECT, PC_OUT);

    always #10 CLK=~CLK;
    initial begin
        $monitor("LD=%b, PCSEL=%b, OFFSET=%b, DIRECT=%b, PC_OUT=%b",LD, PCSEL, OFFSET, DIRECT, PC_OUT);
        CLK = 0;
        RESET =1;
        LD=0;
        #20;
        LD=1;
        RESET =0;
        #30;
        PCSEL=0;
        OFFSET= 'b11111;
        DIRECT= 16'd123;
        for ( i = 0 ; i<= 4 ; i=i+1 ) begin
            #40 PCSEL = PCSEL +1;
        end




    end
endmodule
