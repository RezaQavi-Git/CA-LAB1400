module TB();

    reg clk, rst;

    ARM arm(
        .clk(clk),
        .rst(rst)
    );

    initial begin
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