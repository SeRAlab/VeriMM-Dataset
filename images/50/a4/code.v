module up_down_counter(clk, reset, up_down, q);

    input clk;
    input reset;
    input up_down;
    output [3:0] q;
    reg [3:0] q;
    initial q = 0;

    always @(posedge clk)
        begin
            if (reset)
                q <= 0;
            else
                q <= (up_down) ? q + 1 : q - 1;
        end

endmodule