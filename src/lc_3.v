

module lc_3(RESET, CLK);
    input       RESET;
    input       CLK;
    
    //common bus    
    wire [15:0] COMMON_BUS;
    // SEXT and ZEXT 
    wire [15:0] SEXT4;
    wire [15:0] SEXT5;
    wire [15:0] SEXT8;
    wire [15:0] SEXT10;
    wire [15:0] ZEXT7;
    // register file  
    wire        LDREG;
    wire [2:0]  SR1;
    wire [2:0]  SR2;
    wire [2:0]  DR;
    wire [15:0] SR1_OUT;
    wire [15:0] SR2_OUT;
    // SR2MUX    
    wire        SR2MUX_SEL;
    wire [15:0] SR2MUX_OUT;
    // instruction register
    wire        LDIR;
    wire [15:0] IR_OUT;
    // ALU and GateALU
    wire        GATE_ALU_SEL;
    wire [1:0]  ALUK;
    wire [15:0] ALU_OP_A;
    wire [15:0] ALU_OP_B;
    wire [15:0] ALU_OUT;
    // ADDR1MUX and ADDR2MUX
    wire        ADDR1MUX_SEL;
    wire [1:0]  ADDR2MUX_SEL;
    wire [15:0] ADDR1MUX_OUT;
    wire [15:0] ADDR2MUX_OUT;
    // ADDR
    wire [15:0] ADDR_OUT;
    // PC
    wire        LDPC;
    wire        GATE_PC_SEL;
    wire [1:0]  PC_SEL;
    wire [15:0] PC_OFFSET;
    wire [15:0] PC_DIRECT;
    wire [15:0] PC_OUT;
    // MARMUX and GateMARMUX
    wire        MARMUX_SEL;
    wire        GATE_MARMUX_SEL;
    wire [15:0] MARMUX_OUT;
    // NZP
    wire        LDCC;
    wire        N;
    wire        Z;
    wire        P;
    // Memory
    wire        LDMAR;
    wire        MEM_RW;
    wire        GATE_MDR_SEL;
    wire [1:0]  LDMDR;
    wire [15:0] MAR_OUT;
    wire [15:0] MDR_OUT;
    wire [15:0] MEM_OUT;
    wire [15:0] MDR_IN;
    // sign extensions 
    assign SEXT4[15:5]   = IR_OUT[4];
    assign SEXT4[4:0]    = IR_OUT[4:0];
    assign SEXT5[15:6]   = IR_OUT[5];
    assign SEXT5[5:0]    = IR_OUT[5:0];
    assign SEXT8[15:9]   = IR_OUT[8];
    assign SEXT8[8:0]    = IR_OUT[8:0];
    assign SEXT10[15:11] = IR_OUT[10];
    assign SEXT10[10:0]  = IR_OUT[10:0];
    assign ZEXT7[15:8]   = 1'b0;
    assign ZEXT7[7:0]    = IR_OUT[7:0];
    
    // Register File 
    register_file reg_file_l(.LD(LDREG), .DR(DR), .SR1(SR1), .SR2(SR2), .DR_IN(COMMON_BUS), .SR1_OUT(SR1_OUT), .SR2_OUT(SR2_OUT));
    
    // SR2MUX
    mux16_2to1 sr2mux_l(.SEL(SR2MUX_SEL), .D_IN0(SR2_OUT), .D_IN1(SEXT4), .D_OUT(SR2MUX_OUT));
    
    // ALU and GateALU
    assign ALU_OP_A = SR1_OUT;
    assign ALU_OP_B = SR2MUX_OUT;
    alu alu_l(.ALUK(ALUK), .OP_A(ALU_OP_A), .OP_B(ALU_OP_B), .RESULT(ALU_OUT));   
    tristate_b16 gate_alu_l(.SEL(GATE_ALU_SEL), .D_IN(ALU_OUT), .D_OUT(COMMON_BUS));
    
    // Instruction Register
    register_16 ir_l(.LD(LDIR), .DATA_IN(COMMON_BUS), .DATA_OUT(IR_OUT));
    
    // ADDR1MUX and ADDR2MUX
    mux16_2to1 adDR1mux_l(.SEL(ADDR1MUX_SEL), .D_IN0(SR1_OUT), .D_IN1(PC_OUT), .D_OUT(ADDR1MUX_OUT));
    mux16_4to1 adDR2mux_l(.SEL(ADDR2MUX_SEL), .D_IN0({16{1'b0}}), .D_IN1(SEXT5), .D_IN2(SEXT8), .D_IN3(SEXT10), .D_OUT(ADDR2MUX_OUT));
    
    // ADDR
    add16 adDR_l(.CYI(1'b0), .OP_A(ADDR1MUX_OUT), .OP_B(ADDR2MUX_OUT), .SUM(ADDR_OUT));
    
    // PC and GatePC
    pc pc_l(.CLK(CLK), .RESET(RESET),.LD(LDPC), .PCSEL(PC_SEL), .OFFSET(PC_OFFSET), .DIRECT(PC_DIRECT), .PC_OUT(PC_OUT));
    
    tristate_b16 gate_pc_l(.SEL(GATE_PC_SEL), .D_IN(PC_OUT), .D_OUT(COMMON_BUS));
    
    // MARMUX and GateMARMUX
    mux16_2to1 marmux_l(.SEL(MARMUX_SEL), .D_IN0(ADDR_OUT), .D_IN1(ZEXT7), .D_OUT(MARMUX_OUT));
    tristate_b16 gate_marmux_l(.SEL(GATE_MARMUX_SEL), .D_IN(MARMUX_OUT), .D_OUT(COMMON_BUS));
    
    // NZP logic
    nzp nzp_l(.D_IN(COMMON_BUS), .LD(LDCC), .N(N), .Z(Z), .P(P));
    
    // Memory
    mux16_2to1 mDR_mux(.SEL(LDMDR[0]), .D_IN0(MEM_OUT), .D_IN1(COMMON_BUS), .D_OUT(MDR_IN));
    register_16 mar_l(.LD(LDMAR), .DATA_IN(COMMON_BUS), .DATA_OUT(MAR_OUT));
    register_16 mDR_l(.LD(LDMDR[1]), .DATA_IN(MDR_IN), .DATA_OUT(MDR_OUT));
    ram ram_l(.WE(MEM_RW), .ADDRESS(MAR_OUT), .DATA_IN(MDR_OUT), .DATA_OUT(MEM_OUT));
    tristate_b16 gate_mDR_l(.SEL(GATE_MDR_SEL), .D_IN(MDR_OUT), .D_OUT(COMMON_BUS));

    // FSM Control
    fsm_control fsm_l(.RESET(RESET), .CLK(CLK), .INSTR(IR_OUT), .N(N), .Z(Z), .P(P), .MARMUX_SEL(MARMUX_SEL), .GATE_MARMUX_SEL(GATE_MARMUX_SEL), .PCMUX_SEL(PC_SEL), .LDPC(LDPC), .GATE_PC_SEL(GATE_PC_SEL), .SR1(SR1), .SR2(SR2), .DR(DR), .LDREG(LDREG), .SR2MUX_SEL(SR2MUX_SEL), .ADDR1MUX_SEL(ADDR1MUX_SEL), .ADDR2MUX_SEL(ADDR2MUX_SEL), .ALUK(ALUK), .GATE_ALU_SEL(GATE_ALU_SEL), .LDIR(LDIR), .LDCC(LDCC), .LDMDR(LDMDR), .LDMAR(LDMAR), .MEM_RW(MEM_RW), .GATE_MDR_SEL(GATE_MDR_SEL));
    
    
endmodule

module lc_3_tb;
    reg CLK,RESET;

    lc_3 U_lc_3(RESET, CLK);

    always #10 CLK=~CLK;
    initial begin
        CLK=1;
        RESET =1;
        #50 RESET = 0;
    end

endmodule
