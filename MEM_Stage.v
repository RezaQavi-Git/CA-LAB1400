module MEM_Stage (
    input clk, rst, MEM_W_EN, MEM_R_EN,
    input[31:0] ALU_res, ST_val, 
    inout [31:0] SRAM_DQ,    
    output[31:0] mem_out,
    output ready,
    output [16:0] SRAM_ADDR,
    output SRAM_WE_N
);

SRAM_Controller sram_controller(
    .clk(clk),
    .rst(rst),
    .write_en(MEM_W_EN),
    .read_en(MEM_R_EN),
    .address(ALU_res),
    .writeData(ST_val),
    .readData(mem_out),
    .ready(ready),
    .SRAM_ADDR(SRAM_ADDR),
    .SRAM_WE_N(SRAM_WE_N),
    .SRAM_DQ(SRAM_DQ)
);

assign SRAM_DQ = SRAM_WE_N ? 32'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz : ST_val;

endmodule
