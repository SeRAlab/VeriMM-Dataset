module top_module(
    input d,
    clk,
    output reg q
);always @(posedge clk) q <= d;
endmodule