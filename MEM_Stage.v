module MEM_Stage (
    input clk, rst, MEM_W_EN, MEM_R_EN,
    input[31:0] ALU_res, ST_val, 
    inout [63:0] SRAM_DQ,    
    output[31:0] mem_out,
    output ready,
    output [16:0] SRAM_ADDR,
    output SRAM_WE_N
);

wire [31:0] cache_data;
wire [63:0] read;
wire hit, sram_ready, write, use_sram;
cache_controller cache_controller(
    .clk(clk),
    .rst(rst),
    .write(write),

    .address(ALU_res),
    .sramData(read),
    .MEM_R_EN(MEM_R_EN),
    .MEM_W_EN(MEM_W_EN),
    .rdata(cache_data),
    .hit(hit),
    .use_sram(use_sram)
);


SRAM_Controller sram_controller(
    .clk(clk),
    .rst(rst),
    .use_sram(use_sram),
    .write_en(MEM_W_EN),
    .read_en(MEM_R_EN),
    .address(ALU_res),
    .writeData(ST_val),
    .readData(read),
    .ready(sram_ready),
    .SRAM_ADDR(SRAM_ADDR),
    .SRAM_WE_N(SRAM_WE_N),
    .SRAM_DQ(SRAM_DQ)
);

assign write = sram_ready & MEM_R_EN; 
assign ready = hit | sram_ready;
assign SRAM_DQ = SRAM_WE_N ? 64'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz : {32'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz,ST_val};
assign mem_out = hit ? cache_data : sram_ready ?(ALU_res[2] ? read[63:32] : read[31:0]) : 32'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz;

endmodule
