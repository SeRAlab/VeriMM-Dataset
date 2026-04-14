module top_module(
    input clk,
    input en,
    input reset,
    input [3:0] d,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= 4'b0;  // Synchronous reset
        else if (en)
            q <= d;  // Load data on enable
    end

endmodule