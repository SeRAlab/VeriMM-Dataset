module up_down_counter(clk, rst, up, q);

    input clk;
    input rst;
    input up;
    output [5:0] q;
    reg [5:0] q;

    always @(posedge clk)
    begin
        if (rst)
            q <= 6'b000000;
        else if (up)
            q <= q + 1;
        else
            q <= q - 1;
    end

endmodule