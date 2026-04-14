module top_module(
    input clk,
    input sync_reset,
    input async_reset,
    input shift_en,
    input [3:0] d,
    output reg [3:0] q
);

    // Always block triggered on the rising edge of the clock or on async_reset
    always @(posedge clk or posedge async_reset) begin
        if (async_reset) begin
            q <= 4'b0;  // Asynchronous reset to zero
        end else if (sync_reset) begin
            q <= 4'b0;  // Synchronous reset to zero
        end else if (shift_en) begin
            q <= {q[2:0], d[3]};  // Shift left and load new data
        end
    end

endmodule