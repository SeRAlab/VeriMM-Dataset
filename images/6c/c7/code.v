module counter_10bit(clk, rst, pause, q);

    input clk;
    input rst;
    input pause;
    output [9:0] q;
    reg [9:0] q;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
            q <= 10'b0000000000;
        else if (!pause)
            q <= q + 1;
    end

endmodule