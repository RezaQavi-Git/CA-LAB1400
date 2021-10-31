module IF_Stage (
    input clk, rst, freeze, branchTaken, 
    input[31:0] branchAddr, 
    output[31:0] PC, instruction
);

    wire[31:0] PC_reg_in;
    reg[31:0] PC_reg;

    
    Mux mux(PC, branchAddr, branchTaken, PC_reg_in);

    Adder pcPlus4(PC_reg, 4, PC);
    
    always @(posedge clk, posedge rst) begin
        if (rst)
            PC_reg <= 0;
        else if (~freeze)
            PC_reg <= PC_reg_in;
    end

    Ins_Mem int_mem(PC_reg, instruction);

endmodule
