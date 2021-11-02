module StatusReg (
    input clk, rst,
    input[3:0] in,
    input S,
    output reg[3:0] out
);

    always @(negedge clk, posedge rst) begin
        if (rst)
            out <= 4'b0;
        else if (S)
            out <= in;
    end
    
endmodule

