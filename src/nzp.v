//--------------------------------------------------------------------------------------------
//      Component name  : nzp
//      Description     : The condition register : stores the sign of the input value    
//--------------------------------------------------------------------------------------------


module nzp(D_IN, LD, N, Z, P);
   input [15:0] D_IN;
   input        LD;
   output reg   N;
   output reg   Z;
   output reg   P;

   always @( LD,D_IN )
   begin
      if(LD==1) begin 
         if (D_IN == 16'b0000000000000000) begin
            N  <= 1'b0;
            Z  <= 1'b1;
            P  <= 1'b0;         
         end
         else if (D_IN[15] == 1'b1) begin
            N  <= 1'b1;
            Z  <= 1'b0;
            P  <= 1'b0;         
         end
         else begin
            N  <= 1'b0;
            Z  <= 1'b0;
            P  <= 1'b1;          
         end
      end
      else begin
         N <= N;
         Z <= Z;
         P <= P;
      end
   end
endmodule

module nzp_tb;
   reg [ 15:0 ] D_IN;
   reg LD;
   wire N,Z,P;

   nzp U_nzp(D_IN,LD,N,Z,P);

   initial begin
      $monitor("D_IN = %h ,LD = %h, N=%b,Z=%b,P=%b",D_IN,LD,N,Z,P );
      D_IN = 16'hf011;
      LD = 1;
      #10 LD = 0;
      #10 D_IN = 16'h0111;
      #10 LD = 1;
      #10 LD = 0;
      #10 D_IN = 16'h0000;
      #10 LD = 1;
   end
   
endmodule
