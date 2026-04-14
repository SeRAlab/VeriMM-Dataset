module top_module(
    input clk,
    input enable,
    input clear,
    input [31:0] d,
    output reg [31:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (clear) begin
            q <= 32'b0;  // Synchronous clear to zero
        end else if (enable) begin
            q <= d;  // Load the input data into the register when enabled
        end
    end

endmodule