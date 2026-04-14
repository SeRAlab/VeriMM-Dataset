module top_module(
    input clk,
    input reset,
    input enable,
    output reg [7:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            q <= 8'd0;  // Synchronous reset to 0
        end else if (enable) begin
            q <= q + 8'd1;  // Increment the counter
        end
    end

endmodule