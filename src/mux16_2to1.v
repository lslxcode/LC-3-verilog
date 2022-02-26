
module mux16_2to1(SEL, D_IN0, D_IN1, D_OUT);
   input         SEL;
   input [15:0]  D_IN0;
   input [15:0]  D_IN1;
   output [15:0] D_OUT;

   // ********* The first design method ****************
   // reg [15:0] D_OUT;
   // always @(SEL,D_IN0,D_IN1) begin
   //    case (SEL)
   //       1'b0: D_OUT = D_IN0;
   //       1'b1: D_OUT = D_IN1; 
   //       default: D_OUT = 0; 
   //    endcase
   // end

   //********** the second design method ***************
   assign D_OUT = SEL ? D_IN1 : D_IN0 ;
   
endmodule

module  mux16_2to1_tb;
   reg [15:0]  D_IN0,D_IN1;   // input
   reg         SEL;
   wire[15:0]  D_OUT;  // output
   
   //instantiation
   mux16_2to1 U_mux16_2to1(.SEL(SEL),
                           .D_IN0(D_IN0),
                           .D_IN1(D_IN1),
                           .D_OUT(D_OUT)); 

   initial begin
      $monitor("SEL = %h , D_IN0 = %h ,D_IN1 = %h , D_OUT = %h",SEL,D_IN0,D_IN1,D_OUT);
      D_IN0 = 16'h1234;
      D_IN1 = 16'h1111;
      #10 SEL = 1'b0;
      #10 SEL = 1'b1;
   end

endmodule
