module top_module(
    input d,
    clk,
    pre,
    output reg q
);always @(posedge clk or posedge pre)
    if (pre) q <= 1'b1;
    else q <= d;
endmodule