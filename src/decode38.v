module decoder_3to8(D_IN,D_OUT);
    input  [2:0] D_IN;
    output [7:0] D_OUT;
    
    reg [7:0] D_OUT;

    always @(D_IN) begin
        case(D_IN)
            3'b000: D_OUT = 8'b00000001;
            3'b001: D_OUT = 8'b00000010;
            3'b010: D_OUT = 8'b00000100;
            3'b011: D_OUT = 8'b00001000;
            3'b100: D_OUT = 8'b00010000;
            3'b101: D_OUT = 8'b00100000;
            3'b110: D_OUT = 8'b01000000;
            3'b111: D_OUT = 8'b10000000;
            default: D_OUT = 8'b00000000;
        endcase
    end        
endmodule



module decoder_3to8_tb;
    // Inputs
    reg [2:0] D_IN;

    // Outputs
    wire [7:0] D_OUT;

    // Instantiate the Unit Under Test (UUT)
    decoder_3to8 U_decoder_3to8 (
        .D_IN(D_IN), 
        .D_OUT(D_OUT)
    );

    initial begin
        $monitor("D_IN = %h , D_OUT = %h",D_IN,D_OUT);
        // Add stimulus here
        D_IN <= 3'b000;
        #100;
        D_IN <= 3'b001;
        #100;
        D_IN <= 3'b010;
        #100;
        D_IN <= 3'b011;
        #100;
        D_IN <= 3'b100;
        #100;
        D_IN <= 3'b101;
        #100;
        D_IN <= 3'b110;
        #100;
        D_IN <= 3'b111;
    end
endmodule

