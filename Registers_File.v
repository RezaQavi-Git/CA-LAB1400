module RegisterFile (
    input clk, rst, 
    input[3:0] src1, src2, Dest_wb,
    input[31:0] Result_WB,
    input writeBackEn,
    output [31:0] reg1, reg2
);

    integer i;
    reg [31:0] registers [0:14];
    
    initial begin
        for (i=0; i<15 ; i= i+1 ) begin
            registers[i] = i;
        end
    end

    assign reg1 = registers[src1];
    assign reg2 = registers[src2];

    always @(negedge clk) begin
        if(writeBackEn == 1'b1)
            registers[Dest_wb] <= Result_WB;        
    end
endmodule

