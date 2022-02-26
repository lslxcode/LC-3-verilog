
module mux16_4to1(SEL, D_IN0, D_IN1, D_IN2, D_IN3, D_OUT);
   input [1:0]   SEL;
   input [15:0]  D_IN0;
   input [15:0]  D_IN1;
   input [15:0]  D_IN2;
   input [15:0]  D_IN3;
   output [15:0] D_OUT;

   //********* The first design method ****************
   reg [15:0] D_OUT;

   always @(SEL,D_IN0,D_IN1,D_IN2,D_IN3) begin
      case (SEL)
         2'b00: D_OUT <= D_IN0;
         2'b01: D_OUT <= D_IN1; 
         2'b10: D_OUT <= D_IN2;
         2'b11: D_OUT <= D_IN3;
         default: D_OUT <= 0; 
      endcase
   end   

   //********** the second design method ***************
   // wire [15:0] D_OUT0,D_OUT1;
   // mux16_2to1 U_4to1_sel01(.SEL(SEL[0]), .D_IN0(D_IN0) , .D_IN1(D_IN1) , .D_OUT(D_OUT0));
   // mux16_2to1 U_4to1_sel23(.SEL(SEL[0]), .D_IN0(D_IN2) , .D_IN1(D_IN3) , .D_OUT(D_OUT1));
   // mux16_2to1 U_4to1_sel  (.SEL(SEL[1]), .D_IN0(D_OUT0), .D_IN1(D_OUT1), .D_OUT(D_OUT));   

   //********** the third design method ****************
   // assign D_OUT = SEL[0] ? (SEL[1] ? D_IN3 : D_IN1) :  (SEL[1] ? D_IN2 : D_IN0) ;

endmodule

module  mux16_4to1_tb;
   reg [15:0]  D_IN0,D_IN1,D_IN2,D_IN3;   // input
   reg [ 1:0]  SEL;
   wire[15:0]  D_OUT;  // output
   
   //instantiation
   mux16_4to1 U_mux16_4to1(.SEL(SEL),
                           .D_IN0(D_IN0),
                           .D_IN1(D_IN1),
                           .D_IN2(D_IN2),
                           .D_IN3(D_IN3),
                           .D_OUT(D_OUT)); 
   initial begin
      $monitor("SEL = %h , D_IN0 = %h ,D_IN1 = %h ,D_IN2 = %h ,D_IN3 = %h ,D_OUT = %h",SEL,D_IN0,D_IN1,D_IN2,D_IN3,D_OUT);
      D_IN0 = 16'h1234;
      D_IN1 = 16'h1111;
      D_IN2 = 16'h0011;
      D_IN3 = 16'h1001;

      #10 SEL = 2'b00;
      #10 SEL = 2'b01;
      #10 SEL = 2'b10;
      #10 SEL = 2'b11;
   end
endmodule