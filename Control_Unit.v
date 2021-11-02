module ControlUnit (
    input [1:0] mode,
    input [3:0] Op_code,
    input S,
    output reg [3:0] ExeCommand,
    output reg mem_read, mem_write, WB_Enable, B, update_status 
);
    parameter [3:0] MOV=4'b1101, MVN=4'b1111, ADD=4'b0100, ADC=4'b0101, SUB=4'b0010, SBC=4'b0110, AND=4'b0000,
                    ORR=4'b1100, EOR=4'b0001, CMP=4'b1010, TST=4'b1000, LDR=4'b0100, STR=4'b0100;
    always @(*) begin
        {ExeCommand, mem_read, mem_write, WB_Enable, B, update_status} = 9'b0;


        case (mode)
            2'b00:begin
                update_status = S;

                case (Op_code)
                    MOV:begin
                        ExeCommand = 4'b0001;
                        WB_Enable = 1'b1;
                    end
                    MVN:begin
                        ExeCommand = 4'b1001;
                        WB_Enable = 1'b1;
                    end
                    ADD:begin
                        ExeCommand = 4'b0010;
                        WB_Enable = 1'b1;
                    end
                    ADC:begin 
                        ExeCommand = 4'b0011;
                        WB_Enable = 1'b1;
                    end
                    SUB:begin
                        ExeCommand = 4'b0100;
                        WB_Enable = 1'b1;
                    end
                    SBC:begin 
                        ExeCommand = 4'b0101;
                        WB_Enable = 1'b1;
                    end
                    AND:begin 
                        ExeCommand = 4'b0110;
                        WB_Enable = 1'b1;
                    end
                    ORR:begin
                        ExeCommand = 4'b0111;
                        WB_Enable = 1'b1;
                    end
                    EOR:begin
                        ExeCommand = 4'b1000;
                        WB_Enable = 1'b1;
                    end
                    CMP:begin
                        ExeCommand = 4'b0100;
                    end 
                    TST:begin
                        ExeCommand = 4'b0110;
                    end 
                    default: ExeCommand = 4'b0000;
                endcase

            end
            2'b01:begin
                update_status = S;
                ExeCommand = 4'b0010;
                WB_Enable = S;
                mem_read = (S==1'b1) ? 1'b1 : 1'b0;
                mem_write = (S==1'b1) ? 1'b0 : 1'b1;
            end
            2'b10:begin
                B = 1'b1;
            end 
            default: update_status = 1'b0;
        endcase
    end
    
    
endmodule

