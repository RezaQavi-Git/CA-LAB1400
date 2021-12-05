module EXE_Stage (
    input clk, rst,
    input[3:0] EXE_CMD,
    input MEM_R_EN, MEM_W_EN,
    input[31:0] PC,
    input[31:0] Val_Rm, Val_Rn,
    input imm,
    input[11:0] Shift_operand,
    input[23:0] Signed_imm_24,
    input[3:0] status_IN,
    input[1:0] sel_src1, sel_src2,
    input[31:0] ALU_res_MEM, WB_val,


    output[31:0] ALU_res, Br_addr, ST_val,
    output[3:0] status
);

    wire[31:0] Signed_imm_32 = { {6{Signed_imm_24[23]}}, Signed_imm_24, 2'b00};
    wire mem = MEM_R_EN || MEM_W_EN;
    wire[31:0] Val2;

    wire[31:0] Val1 = sel_src1 == 2'b00 ? Val_Rn : (sel_src1 == 2'b01 ? ALU_res_MEM : WB_val);
    assign   ST_val = sel_src2 == 2'b00 ? Val_Rm : (sel_src2 == 2'b01 ? ALU_res_MEM : WB_val);


    VAL2_Generator val2_generator(
        .Shift_operand(Shift_operand),
        .Val_Rm(ST_val),
        .imm(imm),
        .mem(mem),
        .Val2(Val2)
    );

    ALU alu(
        .val1(Val1),
        .val2(Val2),
        .C_in(status_IN[1]),
        .command(EXE_CMD),
        .out(ALU_res),
        .C_out(status[1]),
        .V(status[0]),
        .Z(status[2]),
        .N(status[3])
    );

    Adder adder(
        .a(PC),
        .b(Signed_imm_32),
        .c(Br_addr)
    );

endmodule
