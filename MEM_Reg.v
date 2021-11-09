module MEM_Reg (
    input clk, rst, WB_EN_MEM, MEM_R_EN_MEM,
    input[31:0] ALU_res_MEM, mem_out_MEM,
    input[3:0] Dest_MEM, 

    output reg WB_EN_WB, MEM_R_EN_WB, 
    output reg[31:0] ALU_res_WB, mem_out_WB,
    output reg[3:0] Dest_WB

);

    // always @(posedge clk, posedge rst) begin
    //     if (rst) begin
    //         PC <= 0;
    //         instruction <= 0;
    //     end else if (flush) begin
    //         PC <= 0;
    //         instruction <= 0;
    //     end else if (~freeze) begin
    //         PC <= PC_in;
    //         instruction <= instruction_in;
    //     end
    // end

endmodule
