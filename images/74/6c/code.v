module top_module (
    input clk,
    input reset,
    input en,
    input d,
    output reg q);always @(posedge clk)
    if (reset)
        q <= 0;
    else if (en)
        q <= d;

endmodule