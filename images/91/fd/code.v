module up_down_counter_4bit(clk, rst, up, down, q);

    input clk;
    input rst;
    input up;
    input down;
    output [3:0] q;
    reg [3:0] q;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
            q <= 4'b0000;
        else if (up && !down)
            q <= q + 1;
        else if (down && !up)
            q <= q - 1;
    end

endmodule