module top_module(
    input clk,
    input sync_load_en,
    input async_reset,
    input [4:0] d,
    output reg [4:0] q
);

    // Always block triggered on the rising edge of the clock or on async_reset
    always @(posedge clk or posedge async_reset) begin
        if (async_reset) begin
            q <= 5'b0;  // Asynchronous reset to zero
        end else if (sync_load_en) begin
            q <= d;  // Load the input data into the register
        end
    end

endmodule