module jkff_async_reset(
    input clk,
    input reset,
    input j,
    input k,
    output reg q);always @(posedge clk or posedge reset)
    if (reset)
        q <= 0;
    else if (j & ~k)
        q <= 1;
    else if (~j & k)
        q <= 0;
    else if (j & k)
        q <= ~q;
        
endmodule