module Total_System (
    input clk, CLK, rst, forward_enable
);

    wire [63:0] SRAM_DQ;
    wire [16:0] SRAM_ADDR;
    wire SRAM_WE_N;

    ARM arm (
        .clk(clk), 
        .rst(rst), 
        .forward_enable(forward_enable),
        .SRAM_DQ(SRAM_DQ),
        .SRAM_ADDR(SRAM_ADDR),
        .SRAM_WE_N(SRAM_WE_N)
    );

    Memory memory (
        .CLK(CLK),
        .RST(rst),
        .SRAM_WE_N(SRAM_WE_N),
        .SRAM_ADDR(SRAM_ADDR),
        .SRAM_DQ(SRAM_DQ)
    );
    
endmodule