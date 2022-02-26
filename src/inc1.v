
module inc1(D_IN, D_OUT);
    input [15:0]  D_IN;
    output [15:0] D_OUT;

    // ********* The first design method **************** 
    // wire [14:0]   CARRY;   
    // half_adder C0 (.A(D_IN[0] ), .B(1'b1     ), .SUM(D_OUT[0] ), .CYO(CARRY[0] ));
    // half_adder C1 (.A(D_IN[1] ), .B(CARRY[0] ), .SUM(D_OUT[1] ), .CYO(CARRY[1] ));
    // half_adder C2 (.A(D_IN[2] ), .B(CARRY[1] ), .SUM(D_OUT[2] ), .CYO(CARRY[2] ));
    // half_adder C3 (.A(D_IN[3] ), .B(CARRY[2] ), .SUM(D_OUT[3] ), .CYO(CARRY[3] ));
    // half_adder C4 (.A(D_IN[4] ), .B(CARRY[3] ), .SUM(D_OUT[4] ), .CYO(CARRY[4] ));
    // half_adder C5 (.A(D_IN[5] ), .B(CARRY[4] ), .SUM(D_OUT[5] ), .CYO(CARRY[5] ));
    // half_adder C6 (.A(D_IN[6] ), .B(CARRY[5] ), .SUM(D_OUT[6] ), .CYO(CARRY[6] ));
    // half_adder C7 (.A(D_IN[7] ), .B(CARRY[6] ), .SUM(D_OUT[7] ), .CYO(CARRY[7] ));
    // half_adder C8 (.A(D_IN[8] ), .B(CARRY[7] ), .SUM(D_OUT[8] ), .CYO(CARRY[8] ));
    // half_adder C9 (.A(D_IN[9] ), .B(CARRY[8] ), .SUM(D_OUT[9] ), .CYO(CARRY[9] ));
    // half_adder C10(.A(D_IN[10]), .B(CARRY[9] ), .SUM(D_OUT[10]), .CYO(CARRY[10]));
    // half_adder C11(.A(D_IN[11]), .B(CARRY[10]), .SUM(D_OUT[11]), .CYO(CARRY[11]));
    // half_adder C12(.A(D_IN[12]), .B(CARRY[11]), .SUM(D_OUT[12]), .CYO(CARRY[12]));
    // half_adder C13(.A(D_IN[13]), .B(CARRY[12]), .SUM(D_OUT[13]), .CYO(CARRY[13]));
    // half_adder C14(.A(D_IN[14]), .B(CARRY[13]), .SUM(D_OUT[14]), .CYO(CARRY[14]));
    // half_adder C15(.A(D_IN[15]), .B(CARRY[14]), .SUM(D_OUT[15]));

    //********** the second design method ***************
    assign D_OUT = D_IN + 1; 

endmodule

module  inc1_tb;
    reg [15:0]  D_IN;   // input
    wire[15:0]  D_OUT;  // output

    inc1 INC_PC(.D_IN(D_IN),.D_OUT(D_OUT)); //instantiation

    initial begin
        $monitor("D_IN = %h , D_OUT = %h",D_IN,D_OUT);
        #10 D_IN = 16'h1234;
        #10 D_IN = 16'h0000;
        #10 D_IN = 16'hffff;
        #10 D_IN = 16'h000f;
    end

endmodule