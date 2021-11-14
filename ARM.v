module ARM (
    input clk, rst
);

    wire branchTaken;
    wire[31:0] branchAddr;

// IF Stage
    wire[31:0] PC_IF, inst_IF;

// ID Stage  
    wire wb_en_ID, mem_r_en_ID, mem_w_en_ID, b_ID, s_ID, imm_ID, hazard, use_src1; 
    wire[3:0] exe_cmd_ID, dest_ID, src1_ID, src2_ID;
    wire[31:0] val_rn_ID, val_rm_ID, PC_ID, inst_ID;
    wire[11:0] shift_operand_ID;
    wire[23:0] signed_imm_24_ID;
    wire Two_src;

// EXE Stage
    wire wb_en_EXE, mem_r_en_EXE, mem_w_en_EXE, s_EXE, imm_EXE; 
    wire[3:0] exe_cmd_EXE, dest_EXE;
    wire[31:0] val_rn_EXE, val_rm_EXE, ALU_res_EXE, PC_EXE;
    wire[11:0] shift_operand_EXE;
    wire[23:0] signed_imm_24_EXE;

// MEM Stage
    wire wb_en_MEM, mem_r_en_MEM, mem_w_en_MEM;
    wire[31:0] ALU_res_MEM, ST_val_MEM, mem_out_MEM;
    wire[3:0] Dest_MEM;
    
// WB Stage
    wire WB_EN_WB, MEM_R_EN_WB;
    wire[31:0] ALU_res_WB, mem_out_WB, WB_value;
    wire[3:0] Dest_WB;


    wire[3:0] status_EXE_in, status_EXE_out, status_ID;
    StatusReg status_reg (
        .clk(clk),
        .rst(rst),
        .in(status_EXE_out),
        .S(s_EXE),
        .out(status_ID)
    );


    IF_Stage if_stage(
        .clk(clk), 
        .rst(rst),
        .freeze(1'b0),
        .branchTaken(branchTaken),
        .branchAddr(branchAddr),
        .PC(PC_IF),
        .instruction(inst_IF)
    );

    IF_Reg if_reg(
        .clk(clk), 
        .rst(rst),
        .freeze(1'b0),
        .flush(1'b0),
        .PC_in(PC_IF),
        .instruction_in(inst_IF),
        .PC(PC_ID),
        .instruction(inst_ID)
    );

    ID_Stage id_stage(
        .clk(clk), 
        .rst(rst),
        .Instruction(inst_ID),
        .Result_WB(WB_value),
        .writeBackEn(WB_EN_WB),
        .Dest_wb(Dest_WB),
        .hazard(1'b0),
        .SR(status_ID),

        .WB_EN(wb_en_ID), 
        .MEM_R_EN(mem_r_en_ID), 
        .MEM_W_EN(mem_w_en_ID), 
        .B(b_ID), 
        .S(s_ID),
        .Two_src(Two_src),
        .EXE_CMD(exe_cmd_ID),
        .Val_Rn(val_rn_ID), 
        .Val_Rm(val_rm_ID),
        .imm(imm_ID),
        .shift_operand(shift_operand_ID),
        .signed_imm_24(signed_imm_24_ID),
        .Dest(dest_ID),
        .src1(src1_ID), 
        .src2(src2_ID),
        .use_src1(use_src1)
    );

    ID_Reg id_reg(
        .clk(clk), 
        .rst(rst), 
        .flush(branchTaken),
        .WB_EN_IN(wb_en_ID), 
        .MEM_R_EN_IN(mem_r_en_ID), 
        .MEM_W_EN_IN(mem_w_en_ID),
        .B_IN(b_ID), 
        .S_IN(s_ID),
        .EXE_CMD_IN(exe_cmd_ID),
        .PC_in(PC_ID),
        .Val_Rn_IN(val_rn_ID), 
        .Val_Rm_IN(val_rm_ID),
        .imm_IN(imm_ID),
        .shift_operand_IN(shift_operand_ID),
        .Signed_imm_24_IN(signed_imm_24_ID),
        .Dest_IN(dest_ID),
        .status_IN(status_ID),

        .WB_EN(wb_en_EXE), 
        .MEM_R_EN(mem_r_en_EXE), 
        .MEM_W_EN(mem_w_en_EXE), 
        .B(branchTaken), 
        .S(s_EXE),
        .EXE_CMD(exe_cmd_EXE),
        .PC(PC_EXE),
        .Val_Rn(val_rn_EXE), 
        .Val_Rm(val_rm_EXE),
        .imm(imm_EXE),
        .Shift_operand(shift_operand_EXE),
        .Signed_imm_24(signed_imm_24_EXE),
        .Dest(dest_EXE),
        .status(status_EXE_in)
    );


    EXE_Stage exe_stage(
        .clk(clk),
        .rst(rst),
        .EXE_CMD(exe_cmd_EXE),
        .MEM_R_EN(mem_r_en_EXE),
        .MEM_W_EN(mem_w_en_EXE),
        .PC(PC_EXE),
        .Val_Rm(val_rm_EXE),
        .Val_Rn(val_rn_EXE),
        .imm(imm_EXE),
        .Shift_operand(shift_operand_EXE),
        .Signed_imm_24(signed_imm_24_EXE),
        .status_IN(status_EXE_in),

        .ALU_res(ALU_res_EXE),
        .Br_addr(branchAddr),
        .status(status_EXE_out)

    );

    EXE_Reg exe_reg(
        .clk(clk),
        .rst(rst),
        .WB_en_in(wb_en_EXE),
        .MEM_R_EN_in(mem_r_en_EXE),
        .MEM_W_EN_in(mem_w_en_EXE),
        .ALU_res_in(ALU_res_EXE),
        .ST_val_in(val_rm_EXE),
        .Dest_in(dest_EXE),

        .WB_en(wb_en_MEM),
        .MEM_R_EN(mem_r_en_MEM),
        .MEM_W_EN(mem_w_en_MEM),
        .ALU_res(ALU_res_MEM),
        .ST_val(ST_val_MEM),
        .Dest(Dest_MEM)

    );

    MEM_Stage mem_stage(
        .clk(clk),
        .rst(rst),
        .MEM_W_EN(mem_w_en_MEM),
        .MEM_R_EN(mem_r_en_MEM),
        .ALU_res(ALU_res_MEM),
        .ST_val(ST_val_MEM),

        .mem_out(mem_out_MEM)

    );

    MEM_Reg mem_reg(
        .clk(clk),
        .rst(rst),
        .WB_EN_MEM(wb_en_MEM),
        .MEM_R_EN_MEM(mem_r_en_MEM),
        .ALU_res_MEM(ALU_res_MEM),
        .mem_out_MEM(mem_out_MEM),
        .Dest_MEM(Dest_MEM),
        
        .WB_EN_WB(WB_EN_WB),
        .MEM_R_EN_WB(MEM_R_EN_WB),
        .ALU_res_WB(ALU_res_WB),
        .mem_out_WB(mem_out_WB),
        .Dest_WB(Dest_WB)

    );
    WB_Stage wb_stage(
        .clk(clk),
        .rst(rst),
        .MEM_R_EN(MEM_R_EN_WB),
        .ALU_res(ALU_res_WB),
        .mem_out(mem_out_WB),

        .WB_value(WB_value)
    ); 


endmodule
