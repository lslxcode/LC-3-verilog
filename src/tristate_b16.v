

module tristate_b16(SEL, D_IN, D_OUT);
    input         SEL;
    input [15:0]  D_IN;
    output[15:0]  D_OUT;

    // ********* The first design method ****************  
    // reg   [15:0]  D_OUT;

    // always @(SEL or D_IN)
    // begin: tb
    //    if (SEL == 1'b1)
    //       D_OUT <= D_IN;
    //    else
    //       D_OUT <= {16{1'bZ}};
    // end

    //********** the second design method ***************
    assign D_OUT = SEL ? D_IN : 'bz; 
    
endmodule

module  tristate_b16_tb;
    reg [15:0]  D_IN;   // input
    reg         SEL;
    wire[15:0]  D_OUT;  // output
    
    //instantiation
    tristate_b16 U_tristate_b16(.SEL(SEL),
                                .D_IN(D_IN),
                                .D_OUT(D_OUT)); 
    initial begin
        $monitor("SEL = %h , D_IN = %h , D_OUT = %h",SEL,D_IN,D_OUT);
        D_IN    = 16'h1234;
        #10 SEL = 1'b0;
        #10 SEL = 1'b1;
    end
endmodule