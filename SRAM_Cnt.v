module SRAM_Controller (
    input clk,
    input rst,
    input use_sram,
    input write_en,
    input read_en,
    input [31:0] address,
    input [31:0] writeData,

    output reg[63:0] readData,

    output ready,

    input [63:0] SRAM_DQ,
    output [16:0] SRAM_ADDR,
    output SRAM_WE_N
);
    assign SRAM_ADDR = (address[16:0] - 1024) >> 2;
    assign SRAM_DQ = write_en ? {32'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz,writeData} : 64'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz;


    reg [2:0] i;
    always @(posedge clk, posedge rst) begin
        if (rst)
            i <= 0;            
        else if(use_sram)begin 
            if ((i == 5) || (i == 6))
                i <= 0;
            else if (i == 0) begin
                if (write_en || read_en)
                    i <= i + 1;
            end else begin
                i <= i + 1;
            end
        end
    end
    assign ready = (!write_en && !read_en) || i == 5;

    assign SRAM_WE_N = ~write_en;
        
    always @(posedge clk, posedge rst) begin
        if (rst)
            readData <= 64'b0;
        else 
        if(use_sram)begin
            if (read_en)
                readData <= SRAM_DQ;
            else
                readData <= 64'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz;
        end
    end

endmodule

