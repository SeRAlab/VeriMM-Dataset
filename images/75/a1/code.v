module tff_sync_reset(
    input clk,
    input reset,
    input t,
    output reg q);always @(posedge clk)
    if (reset)
        q <= 0;
    else if (t)
        q <= ~q;
        
endmodule