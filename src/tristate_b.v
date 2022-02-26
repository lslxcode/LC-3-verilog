
module tristate_b(D_IN, SEL, D_OUT);
   input   D_IN;
   input   SEL;
   output  D_OUT;

   // ********* The first design method ****************   
   // reg     D_OUT;  
   // always @(SEL or D_IN)
   // begin
   //    if (SEL == 1'b1)
   //       D_OUT <= D_IN;
   //    else
   //       D_OUT <= 1'bZ;
   // end

   //********** the second design method *************** 
   assign D_OUT = SEL ? D_IN : 1'bz; 
    
endmodule

module  tristate_b_tb;
   reg  D_IN;   // input
   reg  SEL;
   wire D_OUT;  // output
   
   //instantiation
   tristate_b U_tristate_b(.SEL(SEL),
                           .D_IN(D_IN),
                           .D_OUT(D_OUT)); 
   initial begin
      $monitor("SEL = %h , D_IN = %h , D_OUT = %h",SEL,D_IN,D_OUT);
      D_IN    = 1'b1;
      #10 SEL = 1'b0;
      #10 SEL = 1'b1;
      #10
      D_IN    = 1'b0;
      #10 SEL = 1'b0;
      #10 SEL = 1'b1;
   end
endmodule