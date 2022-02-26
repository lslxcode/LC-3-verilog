
module full_adder(A, B, CYI, SUM, CYO);
    input   A;
    input   B;
    input   CYI;
    output  SUM;
    output  CYO;
        
    wire    A_XOR_B;
    
    assign A_XOR_B = A ^ B;
    assign SUM = (A_XOR_B) ^ CYI;
    assign CYO = ((A_XOR_B) & CYI) | (A & B);
    
endmodule

module full_adder_tb;
	reg A,B,CYI;		// input
	wire SUM,CYO;	// output

	full_adder U_full_adder( .A(A), .B(B), .CYI(CYI), .SUM(SUM), .CYO(CYO));

	initial begin
		$monitor("A = %b , B = %b CYI = %b, SUM = %b , CYO = %b",A,B,CYI,SUM,CYO);
		#10 A=0; B=0; CYI=0;	// SUM=0, CYO=0
		#10 A=0; B=1; CYI=0;	// SUM=1, CYO=0
		#10 A=1; B=0; CYI=0;	// SUM=1, CYO=0
		#10 A=1; B=1; CYI=0;	// SUM=0, CYO=1
      #10 A=0; B=0; CYI=1;	// SUM=1, CYO=0
		#10 A=0; B=1; CYI=1;	// SUM=0, CYO=1
		#10 A=1; B=0; CYI=1;	// SUM=0, CYO=1
		#10 A=1; B=1; CYI=1;	// SUM=1, CYO=1
	end

endmodule