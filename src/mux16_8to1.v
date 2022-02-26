
module mux16_8to1(  SEL,   D_IN0, D_IN1, D_IN2, D_IN3,
                    D_IN4, D_IN5, D_IN6, D_IN7, D_OUT);
   input [2:0]   SEL;
   input [15:0]  D_IN0, D_IN1, D_IN2, D_IN3, D_IN4, D_IN5, D_IN6, D_IN7;

   output [15:0] D_OUT;

   // ********* The first design method ****************
   reg [15:0] D_OUT;
   always @(SEL,D_IN0,D_IN1,D_IN2, D_IN3, D_IN4, D_IN5, D_IN6, D_IN7) begin
      case (SEL)
         3'b000: D_OUT = D_IN0;
         3'b001: D_OUT = D_IN1; 
         3'b010: D_OUT = D_IN2;
         3'b011: D_OUT = D_IN3;
         3'b100: D_OUT = D_IN4;
         3'b101: D_OUT = D_IN5; 
         3'b110: D_OUT = D_IN6;
         3'b111: D_OUT = D_IN7;
         default: D_OUT = 0; 
      endcase
   end   
endmodule

module  mux16_8to1_tb;
    reg [15:0]  D_IN0, D_IN1, D_IN2, D_IN3, D_IN4, D_IN5, D_IN6, D_IN7;   // input
    reg [ 2:0]  SEL;
    wire[15:0]  D_OUT;  // output
    
    //instantiation
    mux16_8to1 U_mux16_8to1( SEL,   D_IN0, D_IN1, D_IN2, D_IN3,
                                D_IN4, D_IN5, D_IN6, D_IN7, D_OUT); 
    initial begin
        $monitor("SEL = %b ,D_OUT = %h",SEL,D_OUT);
        D_IN0 = 16'h1234;
        D_IN1 = 16'h0123;
        D_IN2 = 16'h0012;
        D_IN3 = 16'h1001;
        D_IN4 = 16'h1234;
        D_IN5 = 16'h0123;
        D_IN6 = 16'h0012;
        D_IN7 = 16'h1001;
        $display("D_IN0 = %h ,D_IN1 = %h ,D_IN2 = %h ,D_IN3 = %h",D_IN0, D_IN1, D_IN2, D_IN3);
        $display("D_IN4 = %h ,D_IN5 = %h ,D_IN6 = %h ,D_IN7 = %h",D_IN4, D_IN5, D_IN6, D_IN7);
        #10 SEL = 3'b000;
        #10 SEL = 3'b001;
        #10 SEL = 3'b010;
        #10 SEL = 3'b011;
        #10 SEL = 3'b100;
        #10 SEL = 3'b101;
        #10 SEL = 3'b110;
        #10 SEL = 3'b111;
    end
endmodule
