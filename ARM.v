module ARM (
    input clk, rst
);

    wire branchTaken;
    wire[31:0] branchAddr;

    wire[31:0] PC_IF, Inst_IF;
    
    wire wb_en_ID, mem_r_en_ID, mem_w_en_ID, b_ID, s_ID, imm_ID, hazard, use_src1; 
    wire[3:0] exe_cmd_ID, dest_ID, src1_ID, src2_ID;
    wire[31:0] val_rn_ID, val_rm_ID, PC_ID, inst_ID;
    wire[11:0] shift_operand_ID;
    wire[23:0] signed_imm_24_ID;
    wire Two_src;

    wire wb_en_EXE, mem_r_en_EXE, mem_w_en_EXE, s_EXE, imm_EXE; 
    wire[3:0] exe_cmd_EXE, dest_EXE;
    wire[31:0] val_rn_EXE, val_rm_EXE, ALU_res_EXE, PC_EXE;
    wire[11:0] shift_operand_EXE;
    wire[23:0] signed_imm_24_EXE;



    wire[31:0] PC_MEM, Inst_MEM;
    wire[31:0] PC_FINAL, Inst_FINAL;

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
        .branchTaken(1'b0),
        .branchAddr(0),
        .PC(PC_IF),
        .instruction(Inst_IF)
    );

    IF_Reg if_reg(
        .clk(clk), 
        .rst(rst),
        .freeze(1'b0),
        .flush(1'b0),
        .PC_in(PC_IF),
        .instruction_in(Inst_IF),
        .PC(PC_ID),
        .instruction(Inst_ID)
    );

    ID_Stage id_stage(
        .clk(clk), 
        .rst(rst),
        .Instruction(inst_ID),
        .Result_WB(WB_value),
        .writeBackEn(WB_EN_WB),
        .Dest_wb(Dest_WB),
        .hazard(hazard),
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
        .PC_in(PC_EXE),
        .PC(PC_EXE)
    );

    EXE_Reg exe_reg(
        .clk(clk), 
        .rst(rst),
        .freeze(1'b0),
        .flush(1'b0),
        .PC_in(PC_EXE),
        .instruction_in(Inst_EXE),
        .PC(PC_MEM),
        .instruction(Inst_MEM)
    );

    MEM_Stage mem_stage(
        .clk(clk),
        .rst(rst),
        .PC_in(PC_MEM),
        .PC(PC_MEM)
    );

    MEM_Reg mem_reg(
        .clk(clk), 
        .rst(rst),
        .freeze(1'b0),
        .flush(1'b0),
        .PC_in(PC_MEM),
        .instruction_in(Inst_MEM),
        .PC(PC_FINAL),
        .instruction(Inst_FINAL)
    );
    WB_Stage wb_stage(
        .clk(clk),
        .rst(rst),
        .PC_in(PC_FINAL),
        .PC(PC_FINAL)
    ); 


endmodule
