module ID_Reg (
    input clk, rst, flush, freeze,
    input WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN,
    input B_IN, S_IN,
    input [3:0] EXE_CMD_IN,
    input[31:0] PC_in,
    input [31:0] Val_Rn_IN, Val_Rm_IN,
    input imm_IN,
    input [11:0] shift_operand_IN,
    input [23:0] Signed_imm_24_IN,
    input [3:0] Dest_IN, status_IN, src1_IN, src2_IN,
    input use_src1_IN, use_src2_IN,

    output reg WB_EN, MEM_R_EN, MEM_W_EN, B, S,
    output reg[3:0] EXE_CMD,
    output reg[31:0] PC,
    output reg[31:0] Val_Rn, Val_Rm,
    output reg imm,
    output reg [11:0] Shift_operand,
    output reg [23:0] Signed_imm_24,
    output reg [3:0] Dest, status, src1, src2,
    output reg use_src1, use_src2

);

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            PC <= 0;
            {WB_EN, MEM_R_EN, MEM_W_EN, B, S, EXE_CMD, Val_Rn, Val_Rm, imm, Shift_operand, Signed_imm_24, Dest, status, src1, src2, use_src1, use_src2} <= 128'b0;
        end else if (flush) begin
                PC <= 0;
                {WB_EN, MEM_R_EN, MEM_W_EN, B, S, EXE_CMD, Val_Rn, Val_Rm, imm, Shift_operand, Signed_imm_24, Dest, status, src1, src2, use_src1, use_src2} <= 118'b0;
            end else if (~freeze) begin
                PC <= PC_in;
                {WB_EN, MEM_R_EN, MEM_W_EN, B, S, EXE_CMD, Val_Rn, Val_Rm, imm, Shift_operand, Signed_imm_24, Dest, status, src1, src2, use_src1, use_src2} <= 
                {WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN, B_IN, S_IN, EXE_CMD_IN, Val_Rn_IN, Val_Rm_IN, imm_IN, shift_operand_IN, Signed_imm_24_IN, Dest_IN, status_IN, src1_IN, src2_IN, use_src1_IN, use_src2_IN};
            end
    end

endmodule
