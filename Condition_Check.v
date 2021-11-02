module ConditionCheck
(
    input [3:0] cond,
    input [3:0] SR,
    output reg Is_True
);
    
    // SR[0] -> V
    // SR[1] -> C
    // SR[2] -> Z
    // SR[3] -> N

    always @(*) begin
        Is_True = 1'b0;
        case (cond)
            4'b0000: Is_True = SR[2]; // Z set
            4'b0001: Is_True = !SR[2]; // Z clear
            4'b0010: Is_True = SR[1]; // C set
            4'b0011: Is_True = !SR[1]; // C clear
            4'b0100: Is_True = SR[3]; // N set
            4'b0101: Is_True = !SR[3]; // N clear
            4'b0110: Is_True = SR[0]; // V set
            4'b0111: Is_True = !SR[0]; // V clear
            4'b1000: Is_True = SR[1] ? !SR[2] : 1'b0; // C set and Z clear
            4'b1001: Is_True = SR[2] ? !SR[1] : 1'b0; // C clear or Z set
            4'b1010: Is_True = SR[3] == SR[0] ? 1'b1 : 1'b0; // N==V
            4'b1011: Is_True = SR[3] != SR[0] ? 1'b1 : 1'b0; // N!=V
            4'b1100: Is_True = SR[2] ? 1'b0 : (SR[3] == SR[0] ? 1'b1 : 1'b0); // Z==0, N==V
            4'b1101: Is_True = SR[2] ? (SR[3] != SR[0] ? 1'b1 : 1'b0) : 1'b0; // Z==1 or N!=V
            4'b1110: Is_True = 1'b1;
            default: Is_True = 1'b0;
        endcase
        
    end

endmodule

