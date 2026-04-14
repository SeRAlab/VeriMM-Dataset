module up_down_counter_4bit(clk, rst, dir, q);

    input clk;
    input rst;
    input dir;
    output [3:0] q;
    reg [3:0] q;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
            q <= 4'b0000;
        else if (dir)
            q <= q + 1;
        else
            q <= q - 1;
    end

endmodule