module top_module(input clk, d, r, output reg q);always @(negedge clk or posedge r)
    if (r) q <= 1'b1;
    else q <= d;
endmodule