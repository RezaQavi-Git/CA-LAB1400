module cache_controller (
    input clk,
    input rst,

    input write,
    input [31:0] address,
    input [63:0] sramData,
    input MEM_R_EN,
    input MEM_W_EN,
    output [31:0] rdata,
    output reg hit,
    output reg use_sram
);
    reg [74:0] way0 [0:63];
    reg [74:0] way1  [0:63];
    reg [0:63] lastUse;
    reg [63:0] data;
    wire [9:0] tag;
    wire [5:0] index;

    integer i;
    initial begin
        for (i = 0 ; i < 64 ; i = i+1 ) begin
            way0[i][0] = 1'b0;
            way1[i][0] = 1'b0;
            lastUse[i] = 1'b1;
        end
    end
    assign tag = address[18:9];
    assign index = address[8:3];
    always @(posedge clk , posedge rst) begin
        if(MEM_W_EN)begin
            use_sram <= 1'b1;
            if(way0[index][10:1] == tag)begin
                if(way0[index][0] == 1'b1)begin
                    way0[index][0] = 1'b0;
                    lastUse[index] = 1'b1;
                end
            end 
            else if(way1[index][10:1] == tag)begin
                if(way1[index][0] == 1'b1)begin
                    way1[index][0] = 1'b0;
                    lastUse[index] = 1'b0;
                end
            end 
        end
        if(MEM_R_EN)begin
            if(write)begin
                if(lastUse[index] == 1'b0)begin
                    way1[index] <= {sramData,tag, 1'b1};
                    lastUse[index] = 1'b1;
                    data <= sramData;
                end
                else begin
                    way0[index] <= {sramData,tag, 1'b1};
                    lastUse[index] = 1'b0;
                    data <= sramData;
                end
            end
        end
         
    end
    always @(*)begin
        {hit, use_sram} <= 2'b00;
        if(MEM_R_EN)begin
            if(way0[index][10:1] == tag && way0[index][0] == 1'b1)begin
                hit <= 1'b1;
                data <= way0[index][74:11];
                lastUse[index] = 1'b0;
            end
            else if(way1[index][10:1] == tag && way1[index][0] == 1'b1)begin
                hit <= 1'b1;
                data <= way1[index][74:11];
                lastUse[index] = 1'b1;
            end
            else 
                use_sram <= 1'b1;
        end

    end
    assign rdata = address[2] ? data[63:32] : data[31:0];

endmodule
