module top_module(clk, d, q);input clk;
    input d;
    output reg q;

    always @(posedge clk)
         q <= d;
endmodule