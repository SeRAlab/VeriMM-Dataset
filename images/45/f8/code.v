module top_module(
    input clk,
    input enable,
    input reset,
    input [23:0] d,
    output reg [23:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            q <= 24'b0;  // Synchronous reset to zero
        end else if (enable) begin
            q <= d;  // Load the input data into the register
        end
    end

endmodule