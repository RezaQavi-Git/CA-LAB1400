module MEM_Reg (
    input clk, rst, WB_EN_MEM, MEM_R_EN_MEM,
    input[31:0] ALU_res_MEM, mem_out_MEM,
    input[3:0] Dest_MEM, 

    output reg WB_EN_WB, MEM_R_EN_WB, 
    output reg[31:0] ALU_res_WB, mem_out_WB,
    output reg[3:0] Dest_WB
);

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            WB_EN_WB <= 1'b0;
            MEM_R_EN_WB <= 1'b0;
            ALU_res_WB <= 32'b0;
            mem_out_WB <= 32'b0;
            Dest_WB <= 4'b0;
        end else begin
            WB_EN_WB <= WB_EN_MEM;
            MEM_R_EN_WB <= MEM_R_EN_MEM;
            ALU_res_WB <= ALU_res_MEM;
            mem_out_WB <= mem_out_MEM;
            Dest_WB <= Dest_MEM;
        end
    end

endmodule

