module top_module(clk, rst, d, q);parameter width=32;
    input clk;
    input rst;
    input [width-1:0] d;
    output reg [width-1:0] q;

    always @(posedge clk or posedge rst)
        if (rst)
            q <= 32'h08000008;
        else
            q <= d;
endmodule