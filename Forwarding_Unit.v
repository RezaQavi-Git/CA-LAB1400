module forwarding_unit (
    input forward_enable,
    input[3:0] src1, src2,
    input[3:0] Dest_MEM, Dest_WB,
    input wb_en_MEM, wb_en_WB,
    input use_src1, use_src2,

    output reg[1:0] sel_src1, sel_src2
);

    always @(*) begin
        if (~forward_enable || ~use_src1) begin
            sel_src1 = 2'b00;
        end else if (wb_en_MEM && src1 == Dest_MEM) begin
            sel_src1 = 2'b01;
        end else if (wb_en_WB && src1 == Dest_WB) begin
            sel_src1 = 2'b10;
        end else begin
            sel_src1 = 2'b00;
        end
    end

    always @(*) begin
        if (~forward_enable || ~use_src2) begin
            sel_src2 = 2'b00;
        end else if (wb_en_MEM && src2 == Dest_MEM) begin
            sel_src2 = 2'b01;
        end else if (wb_en_WB && src2 == Dest_WB) begin
            sel_src2 = 2'b10;
        end else begin
            sel_src2 = 2'b00;
        end
    end

endmodule

