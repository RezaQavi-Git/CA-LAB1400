module ID_Stage (
    input clk, rst,
    input [31:0] Instruction,
    input [31:0] Result_WB,
    input writeBackEn,
    input [3:0] Dest_wb,
    input hazard,
    input [3:0] SR,

    output WB_EN, MEM_R_EN, MEM_W_EN, B, S,Two_src,
    output [3:0] EXE_CMD,
    output [31:0] Val_Rn, Val_Rm,
    output imm,
    output [11:0] shift_operand,
    output [23:0] signed_imm_24,
    output [3:0] Dest,
    output [3:0] src1, src2,
    output use_src1
);

    wire is_True, not_cond, selector, s_cnt, b_cnt, wb_cnt, mem_w_cnt, mem_r_cnt;
    wire [3:0] exe_cmd_cnt;

    wire[3:0] cond = Instruction[31:28];
    wire[1:0] mode = Instruction[27:26];
    wire I = Instruction[25];
    wire[3:0] opCode = Instruction[24:21];
    wire s_in = Instruction[20];
    wire[3:0] Rn = Instruction[19:16];
    wire[3:0] Rd = Instruction[15:12];
    wire[3:0] Rm = (mode == 2'b01 ? Instruction[15:12] : Instruction[3:0]);
    assign shift_operand = Instruction[11:0];
    assign signed_imm_24 = Instruction[23:0];

    RegisterFile registerFile (
        .clk(clk), 
        .rst(rst), 
        .src1(Rn), 
        .src2(Rm), 
        .Dest_wb(Dest_wb), 
        .Result_WB(Result_WB), 
        .writeBackEn(writeBackEn), 
        .reg1(Val_Rn), 
        .reg2(Val_Rm)
    );
    
    ControlUnit cotrolUnit(
        .mode(mode), 
        .Op_code(opCode), 
        .S(s_in), 
        .ExeCommand(exe_cmd_cnt), 
        .mem_read(mem_r_cnt), 
        .mem_write(mem_w_cnt), 
        .WB_Enable(wb_cnt), 
        .B(b_cnt), 
        .update_status(s_cnt)
    );
    
    ConditionCheck conditionCheck(
        .cond(cond), 
        .SR(SR), 
        .Is_True(is_True)
    );

    assign imm = I;
    assign Dest = Rd;
    assign selector = hazard || (!is_True);
    assign {S, B, EXE_CMD, MEM_W_EN, MEM_R_EN, WB_EN} = selector ? 9'b0 : {s_cnt, b_cnt, exe_cmd_cnt, mem_w_cnt, mem_r_cnt, wb_cnt};
    
    assign use_src1 = opCode != 4'b1101 && opCode != 4'b1111 && mode != 2'b10;
    assign Two_src = MEM_W_EN || (!imm && mode == 2'b00);
    assign src1 = Rn;
    assign src2 = Rm;

endmodule
