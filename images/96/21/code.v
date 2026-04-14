module top_module(
    input clk,
    input ss,
    input sr,
    input d,
    output reg q
);always @(posedge clk) begin
        if (ss) // Synchronous set
            q <= 1;
        else if (sr) // Synchronous reset
            q <= 0;
        else // No set or reset
            q <= d;
    end

endmodule