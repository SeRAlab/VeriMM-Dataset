module counter_8bit(clk, rst, q);

    input clk;
    input rst;
    output [7:0] q;
    reg [7:0] q;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
            q <= 8'b00000000;
        else
            q <= q + 1;
    end

endmodule