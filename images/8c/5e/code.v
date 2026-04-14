module top_module(
    input clk,
    input set,
    input reset,
    output reg q);always @(posedge clk)
        if (reset)
            q <= 0;
        else if (set)
            q <= 1;

endmodule