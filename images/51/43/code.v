module top_module(
    input clk,
    input reset,
    input [15:0] d,
    output reg [15:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= 16'b0;  // Synchronous reset
        else
            q <= d;  // Load data
    end

endmodule