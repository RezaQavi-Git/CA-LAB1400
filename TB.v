module TB();

    reg clk, rst, forward_enable;

    ARM arm(
        .clk(clk),
        .rst(rst),
        .forward_enable(forward_enable)

    );

    initial begin
        forward_enable = 1;
        rst = 0;
        #40;
        rst = 1;
        #40
        rst = 0;
    end

    initial begin
        clk = 1;
        repeat(1000) begin
            #50;
            clk = ~clk;
        end
    end


endmodule

// module val2tb();

//     reg[11:0] Shift_operand;
//     reg[31:0] Val_Rm;
//     reg imm, mem;

//     wire[31:0] Val2;

//     Val2_Generator val2 (
//         .Shift_operand(Shift_operand),
//         .Val_Rm(Val_Rm),
//         .imm(imm),
//         .mem(mem),
        
//         .Val2(Val2)
//     );

//     initial begin
//         Shift_operand = 12'b0010_01100011;
//         imm = 1;
//         mem = 0;
//         #10;
//         Val_Rm = 32'b11100011101010000100110000001111;
//         imm = 0;
//         Shift_operand = 12'b00001_00_00000;
//         #10;
//         Shift_operand = 12'b00001_01_00000;
//         #10;
//         Shift_operand = 12'b00001_10_00000;
//         #10;
//         Shift_operand = 12'b00001_11_00000;
//         #10;
//         Shift_operand = 12'b10001_11_00000;
//         mem = 1;
//         #10;
//         Shift_operand = 12'b000000010100;
//         mem = 0;
//         imm = 1;
//         #10;
//     end

// endmodule

// module alutb();

//     reg[31:0] val1, val2;
//     reg[3:0] command;
//     reg Cin;
//     wire[31:0] out;
//     wire Cout, Z, N, V;

//     ALU alu(
//         .val1(val1),
//         .val2(val2),
//         .command(command),
//         .Cin(Cin),
//         .out(out),
//         .Cout(Cout),
//         .Z(Z),
//         .N(N),
//         .V(V)
//     );

//     initial begin
//         Cin = 1;
//         val1 = 5;
//         val2 = 8;
//         command = 4'b0001;
//         #10;
//         command = 4'b1001;
//         #10;
//         command = 4'b0010;
//         #10;
//         command = 4'b0011;
//         #10;
//         command = 4'b0100;
//         #10;
//         command = 4'b0101;
//         #10;
//         command = 4'b0110;
//         #10;
//         command = 4'b0111;
//         #10;
//         command = 4'b1000;
//         #10;
//     end


// endmodule
