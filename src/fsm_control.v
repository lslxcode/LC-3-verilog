///////////////////////////////////////
// INST[15:12]:Specific instructions
// INST[11]: Addressing mode
// PSR[15]
// BEN: Jump

module fsm_control( RESET, CLK, 
                    INSTR, 
                    N, Z, P, 
                    MARMUX_SEL, 
                    GATE_MARMUX_SEL, 
                    PCMUX_SEL, 
                    LDPC, 
                    GATE_PC_SEL, 
                    SR1, SR2, DR, 
                    LDREG, 
                    SR2MUX_SEL, 
                    ADDR2MUX_SEL, ADDR1MUX_SEL, 
                    ALUK, GATE_ALU_SEL,
                     LDIR, LDCC, 
                     LDMDR, LDMAR, MEM_RW, GATE_MDR_SEL);
    input            RESET;
    input            CLK;
    input [15:0]     INSTR;
    input            N;
    input            Z;
    input            P;
    output           MARMUX_SEL;
    output           GATE_MARMUX_SEL;
    output [1:0]     PCMUX_SEL;
    output           LDPC;
    output           GATE_PC_SEL;
    output [2:0]     SR1;
    reg [2:0]        SR1;
    output [2:0]     SR2;
    reg [2:0]        SR2;
    output [2:0]     DR;
    reg [2:0]        DR;
    output           LDREG;
    output           SR2MUX_SEL;
    output [1:0]     ADDR2MUX_SEL;
    output           ADDR1MUX_SEL;
    output [1:0]     ALUK;
    reg [1:0]        ALUK;
    output           GATE_ALU_SEL;
    output           LDIR;
    output           LDCC;
    output [1:0]     LDMDR;
    output           LDMAR;
    output           MEM_RW;
    output           GATE_MDR_SEL;
    
    
    parameter [2:0] fsm_state_F1 = 0,  // FETCH:  PC地址进入存储器
                    fsm_state_F2 = 1,  // FETCH:  取PC指令到IR；下一个指令地址进入PC
                    fsm_state_D  = 2,  // DECODE: 指令译码; 取寄存器文件
                    fsm_state_EA = 3,  // EVALUATE ADDRESS： 地址计算
                    fsm_state_OP = 4,  // FETCH OPERAND：取操作数
                    fsm_state_EX = 5,  // EXECUTE：执行
                    fsm_state_S  = 6;  // STORE RESULT：存放结果

    reg [2:0]        CURRENT_STATE;
    reg [2:0]        NEXT_STATE;
    reg [18:0]       CURRENT_SIGNALS;
    wire [3:0]       OPCODE;
    
    assign OPCODE          = INSTR[15:12];
    assign MARMUX_SEL      = CURRENT_SIGNALS[18];
    assign GATE_MARMUX_SEL = CURRENT_SIGNALS[17];
    assign PCMUX_SEL       = CURRENT_SIGNALS[16:15];
    assign LDPC            = CURRENT_SIGNALS[14];
    assign GATE_PC_SEL     = CURRENT_SIGNALS[13];
    assign LDREG           = CURRENT_SIGNALS[12];
    assign SR2MUX_SEL      = CURRENT_SIGNALS[11];
    assign ADDR2MUX_SEL    = CURRENT_SIGNALS[10:9];
    assign ADDR1MUX_SEL    = CURRENT_SIGNALS[8];
    assign GATE_ALU_SEL    = CURRENT_SIGNALS[7];
    assign LDIR            = CURRENT_SIGNALS[6];
    assign LDCC            = CURRENT_SIGNALS[5];
    assign LDMDR           = CURRENT_SIGNALS[4:3];
    assign LDMAR           = CURRENT_SIGNALS[2];
    assign MEM_RW          = CURRENT_SIGNALS[1];
    assign GATE_MDR_SEL    = CURRENT_SIGNALS[0];
    
    
    always @(posedge CLK or posedge RESET)
    begin: sync_proc
        if (RESET == 1'b1)
            CURRENT_STATE <= fsm_state_F1;
        else 
            CURRENT_STATE <= NEXT_STATE;
    end
    
    
    always @(CURRENT_STATE or RESET)
    begin: comb_proc
        if (RESET == 1'b1)
        begin
            CURRENT_SIGNALS <= 19'b0011110000000000000;
            NEXT_STATE <= fsm_state_F1;
        end
        else
        begin
            CURRENT_SIGNALS <= 19'b0000000000000000000;
            $display("\n %m: At time %0t : CURRENT_STATE = %d",$time,CURRENT_STATE);
            case (CURRENT_STATE)
                fsm_state_F1 :// FETCH:  PC地址进入存储器
                begin
                    // GATE_PC_SEL, LDMAR : put PC address into memory
                    // LDCC : NZP into CONTROL
                    CURRENT_SIGNALS <= 19'b00_00_010000000010100;
                    NEXT_STATE <= fsm_state_F2;
                end 

                fsm_state_F2 : // FETCH:  取PC指令到IR；下一个指令地址进入PC
                begin
                    // GATE_MDR_SEL: get instr from memory
                    // LDIR: IR into CONTROL 
                    // LDPC: next PC address into PC
                    CURRENT_SIGNALS <= 19'b00001000000010_00_001;
                    NEXT_STATE <= fsm_state_D;
                end
                
                fsm_state_D :// DECODE: 指令译码; 取寄存器文件
                begin
                    $display("%m: At time %0t : OPCODE = %b",$time,OPCODE);
                    CURRENT_SIGNALS <= 19'b0000000000000000000;
                        // OPCODE:instructions:
                        // ADD:0001
                        // AND:0101
                        // BR :0000
                        // JMP:1100
                        // JSR:0100
                        // LD :0010
                        // LDI:1010
                        // LDR:0110
                        // LEA:1110
                        // NOT:1001
                        // RTI:1000
                        // ST :0011
                        // STI:1011
                        // STR:0111
                        //TRAP:1111                    
                    if ((OPCODE[1:0] == 2'b10 | OPCODE[1:0] == 2'b11) & OPCODE != 4'b1111)
                        NEXT_STATE <= fsm_state_EA;
                    else
                        NEXT_STATE <= fsm_state_EX;
                    
                    // set ALU mode
                    ALUK <= INSTR[15:14];
                    
                    // source register 
                    SR1 <= INSTR[8:6];
                    SR2 <= INSTR[2:0];
                    
                    // Destination register
                    if (OPCODE == 4'b0100)  // instuction: JSR=0100
                        DR <= 3'b111;
                    else
                        DR <= INSTR[11:9];
                end
                
                fsm_state_EA :// EVALUATE ADDRESS： 地址计算
                begin
                    case (OPCODE)
                        4'd2:  CURRENT_SIGNALS <= 19'b0100000010100010100;  //-- LD
                        4'd3:  CURRENT_SIGNALS <= 19'b0100000010100000100;  //-- ST
                        4'd6:  CURRENT_SIGNALS <= 19'b0100000001000010100;  //-- LDR
                        4'd7:  CURRENT_SIGNALS <= 19'b0100000001000000100;  //-- STR
                        4'd10: CURRENT_SIGNALS <= 19'b0100000010100010100;  //-- LDI
                        4'd11: CURRENT_SIGNALS <= 19'b0100000010100010100;  //-- STI
                        4'd14: CURRENT_SIGNALS <= 19'b0100001010100110000;  //-- LEA                     
                        default:  CURRENT_SIGNALS <= 19'b0000000000000000000;
                    endcase
                    NEXT_STATE <= fsm_state_OP;
                end
                
                fsm_state_OP :
                begin
                    case (OPCODE)
                        4'd2:  CURRENT_SIGNALS <= 19'b0000001000000100001;  //-- LD
                        4'd3:  CURRENT_SIGNALS <= 19'b0100000000000011000;  //-- ST
                        4'd6:  CURRENT_SIGNALS <= 19'b0000001000000100001;  //-- LDR
                        4'd7:  CURRENT_SIGNALS <= 19'b0100000000000011000;  //-- STR
                        4'd10: CURRENT_SIGNALS <= 19'b0000000000000000101;  //-- LDI
                        4'd11: CURRENT_SIGNALS <= 19'b0000000000000000101;  //-- STI
                        4'd14: CURRENT_SIGNALS <= 19'b0100001010100110000;  //-- LEA                     
                        default:  CURRENT_SIGNALS <= 19'b0000000000000000000;
                    endcase
                    NEXT_STATE <= fsm_state_S;
                end
                
                fsm_state_EX :
                begin
                    case (OPCODE)
                        4'd0: CURRENT_SIGNALS <= 19'b0001000010100000000;   //-- BR
                        4'd1: CURRENT_SIGNALS <= 19'b0000000000010100000;   //-- ADD
                        4'd4: CURRENT_SIGNALS <= 19'b0000011000000000000;   //-- JSR
                        4'd5: CURRENT_SIGNALS <= 19'b0000000000010100000;   //-- AND
                        4'd9: CURRENT_SIGNALS <= 19'b0000000000010100000;   //-- NOT
                        4'd12:CURRENT_SIGNALS <= 19'b0001100000000000000;   //-- JMP
                        4'd15:CURRENT_SIGNALS <= 19'b0001111000000000000;   //-- TRAP
                        default: CURRENT_SIGNALS <= 19'b0000000000000000000;
                    endcase
                    NEXT_STATE <= fsm_state_S;
                    
                    if ((OPCODE == 4'b0001 | OPCODE == 4'b0101) & INSTR[5] == 1'b1)
                        CURRENT_SIGNALS[11] <= 1'b1;
                    
                    if (INSTR[11:9] == {N, Z, P})
                        CURRENT_SIGNALS[14] <= 1'b1;
                end
                
                fsm_state_S :
                begin
                    case(OPCODE)
                        4'd0  :  CURRENT_SIGNALS <= 19'b0001000010100000000;//  -- BR
                        4'd1  :  CURRENT_SIGNALS <= 19'b0000001000010100000;//  -- ADD
                        4'd2  :  CURRENT_SIGNALS <= 19'b0000001000000000001;//  -- LD
                        4'd3  :  CURRENT_SIGNALS <= 19'b0000000000000000010;//  -- ST
                        4'd4  :  CURRENT_SIGNALS <= 19'b0001100000000000000;//  -- JSR
                        4'd5  :  CURRENT_SIGNALS <= 19'b0000001000010100000;//  -- AND
                        4'd6  :  CURRENT_SIGNALS <= 19'b0000001000000000001;//  -- LDR
                        4'd7  :  CURRENT_SIGNALS <= 19'b0000000000000000010;//  -- STR
                        4'd9  :  CURRENT_SIGNALS <= 19'b0000001000010100000;//  -- NOT
                        4'd10 :  CURRENT_SIGNALS <= 19'b0000001000000110001;//  -- LDI
                        4'd11 :  CURRENT_SIGNALS <= 19'b0100000000000011010;//  -- STI
                        4'd12 :  CURRENT_SIGNALS <= 19'b0001000000000000000;//  -- JMP
                        4'd14 :  CURRENT_SIGNALS <= 19'b0100001010100000000;//  -- LEA
                        4'd15 :  CURRENT_SIGNALS <= 19'b0001111000000000000;//  -- TRAP
                        default :  CURRENT_SIGNALS <= 19'b0000000000000000000;
                    endcase
                    NEXT_STATE <= fsm_state_F1;
                    
                    if ((OPCODE == 4'b0001 | OPCODE == 4'b0101) & INSTR[5] == 1'b1)
                        CURRENT_SIGNALS[11] <= 1'b1;
                    
                    if (OPCODE == 4'b0100 & INSTR[11] == 1'b1)
                    begin
                        CURRENT_SIGNALS[8] <= 1'b1;
                        CURRENT_SIGNALS[10:9] <= 2'b11;
                    end
                end
                
                default :
                begin
                    CURRENT_SIGNALS <= {19{1'b0}};
                    NEXT_STATE <= fsm_state_F1;
                end
            endcase
        end
    end

endmodule

module fsm_control_tb;
    reg CLK,RESET;

    fsm_control U_fsm_control(.CLK(CLK),.RESET(RESET));

    always #10 CLK=~CLK;
    initial begin
        CLK=1;
        RESET =1;
        #50 RESET = 0;
    end

endmodule