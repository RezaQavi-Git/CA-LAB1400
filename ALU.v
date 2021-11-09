module ALU (
    input[31:0] val1, val2,
    input C_in,
    input[3:0] command,

    output reg[31:0] out,
    output reg C_out, V,
    output N, Z
);

    always @ (*) begin
        out = 32'b0;
        C_out = 1'b0;
        case (command) 
            4'b0001: out = val2;
            4'b1001: out = ~val2;
            4'b0010: {C_out, out} = val1 + val2;
            4'b0011: {C_out, out} = val1 + val2 + C_in;
            4'b0100: {C_out, out} = val1 - val2;
            4'b0101: {C_out, out} = val1 - val2 - 1 + C_in;  
            4'b0110: out = val1 & val2;
            4'b0111: out = val1 | val2;
            4'b1000: out = val1 ^ val2;
            default: {C_out, out} = 33'b0;
        endcase
    end

    assign N = out[31];
    assign Z = (out == 32'b0);

    always @(*) begin
        V = 1'b0;
        case (command)
            4'b0010: V = (val1[31] & val2[31] & (~N)) || ( (~val1[31]) & (~val2[31]) & N);
            4'b0011: V = (val1[31] & val2[31] & (~N)) || ( (~val1[31]) & (~val2[31]) & N);
            4'b0100: V = (val1[31] & (~val2[31]) & (~N)) || ( (~val1[31]) & val2[31] & N);
            4'b0101: V = (val1[31] & (~val2[31]) & (~N)) || ( (~val1[31]) & val2[31] & N);
            default: V = 1'b0;
        endcase
    end

endmodule

