module Ins_Mem (
    input[31:0] inp,
    output[31:0] out
);

    reg[31:0] mem[0:20];

    initial begin
        $readmemb ("instructions.txt", mem);
    end

    assign out = mem[inp>>2];


endmodule
