
module add16(CYI, OP_A, OP_B, CYO, SUM);
    input         CYI;
    input [15:0]  OP_A;
    input [15:0]  OP_B;
    output        CYO;
    output [15:0] SUM;
    
    wire [15:0]   CARRY;
    
    full_adder C0(.A(OP_A[0]), .B(OP_B[0]), .CYI(CYI), .SUM(SUM[0]), .CYO(CARRY[0]));
    full_adder C1(.A(OP_A[1]), .B(OP_B[1]), .CYI(CARRY[0]), .SUM(SUM[1]), .CYO(CARRY[1]));  
    full_adder C2(.A(OP_A[2]), .B(OP_B[2]), .CYI(CARRY[1]), .SUM(SUM[2]), .CYO(CARRY[2]));  
    full_adder C3(.A(OP_A[3]), .B(OP_B[3]), .CYI(CARRY[2]), .SUM(SUM[3]), .CYO(CARRY[3]));  
    full_adder C4(.A(OP_A[4]), .B(OP_B[4]), .CYI(CARRY[3]), .SUM(SUM[4]), .CYO(CARRY[4]));  
    full_adder C5(.A(OP_A[5]), .B(OP_B[5]), .CYI(CARRY[4]), .SUM(SUM[5]), .CYO(CARRY[5]));  
    full_adder C6(.A(OP_A[6]), .B(OP_B[6]), .CYI(CARRY[5]), .SUM(SUM[6]), .CYO(CARRY[6])); 
    full_adder C7(.A(OP_A[7]), .B(OP_B[7]), .CYI(CARRY[6]), .SUM(SUM[7]), .CYO(CARRY[7]));
    full_adder C8(.A(OP_A[8]), .B(OP_B[8]), .CYI(CARRY[7]), .SUM(SUM[8]), .CYO(CARRY[8]));
    full_adder C9(.A(OP_A[9]), .B(OP_B[9]), .CYI(CARRY[8]), .SUM(SUM[9]), .CYO(CARRY[9]));
    full_adder C10(.A(OP_A[10]), .B(OP_B[10]), .CYI(CARRY[9]), .SUM(SUM[10]), .CYO(CARRY[10]));
    full_adder C11(.A(OP_A[11]), .B(OP_B[11]), .CYI(CARRY[10]), .SUM(SUM[11]), .CYO(CARRY[11]));
    full_adder C12(.A(OP_A[12]), .B(OP_B[12]), .CYI(CARRY[11]), .SUM(SUM[12]), .CYO(CARRY[12])); 
    full_adder C13(.A(OP_A[13]), .B(OP_B[13]), .CYI(CARRY[12]), .SUM(SUM[13]), .CYO(CARRY[13]));
    full_adder C14(.A(OP_A[14]), .B(OP_B[14]), .CYI(CARRY[13]), .SUM(SUM[14]), .CYO(CARRY[14]));
    full_adder C15(.A(OP_A[15]), .B(OP_B[15]), .CYI(CARRY[14]), .SUM(SUM[15]), .CYO(CARRY[15]));
    
    assign CYO = CARRY[15];
   
endmodule

module  add16_tb;
    reg         CYI;
    reg [15:0]  OP_A;
    reg [15:0]  OP_B;
    wire        CYO;
    wire [15:0] SUM;

    add16 U_add16(CYI, OP_A, OP_B, CYO, SUM); //instantiation

    initial begin
        $monitor("CYI=%h, OP_A=%h, OP_B=%h, CYO=%h, SUM=%h",CYI, OP_A, OP_B, CYO, SUM);
		#10 OP_A=16'h1111; OP_B=16'h1111; CYI=0;	
		#10 OP_A=16'h1111; OP_B=16'h0000; CYI=0;

      #10 OP_A=16'h1111; OP_B=16'h1100; CYI=1;	
		#10 OP_A=16'h1111; OP_B=16'h1234; CYI=1;	

    end

endmodule