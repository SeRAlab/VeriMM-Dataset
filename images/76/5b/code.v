module top_module(
    input clk,
    input reset,
    input enable,
    input [7:0] data,
    output reg [7:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            q <= 8'd0;  // Synchronous reset to all zeros
        end else if (enable) begin
            q <= data;  // Synchronous enable to capture data input
        end
    end

endmodule