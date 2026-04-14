module top_module(
    input clk,
    input sync_reset,
    input async_reset,
    input [9:0] d,
    output reg [9:0] q
);

    // Always block triggered on the rising edge of the clock or on async_reset
    always @(posedge clk or posedge async_reset) begin
        if (async_reset) begin
            q <= 10'b0;  // Asynchronous reset to zero
        end else if (sync_reset) begin
            q <= 10'b0;  // Synchronous reset to zero
        end else begin
            q <= d;  // Load the input data into the register
        end
    end

endmodule