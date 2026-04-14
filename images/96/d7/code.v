module top_module(
    input clk,
    input reset,
    input d,
    output reg q
);

    always @(posedge clk) begin
        if (reset)
            q <= 1'b0;  // Synchronous reset
        else
            q <= d;  // Load data
    end

endmodule