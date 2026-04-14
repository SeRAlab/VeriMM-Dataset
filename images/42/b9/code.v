module top_module(
    input clk,
    input reset,
    input enable,
    output reg [1:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            q <= 2'b00;  // Synchronous reset to 2'b00
        end else if (enable) begin
            q <= q + 2'b01;  // Increment the counter if enabled
        end
    end

endmodule