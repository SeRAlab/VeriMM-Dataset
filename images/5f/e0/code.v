module top_module(
    input clk,
    input reset,
    output reg [2:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            q <= 3'd0;  // Synchronous reset to 0
        end else begin
            q <= q + 3'd1;  // Increment the counter
        end
    end

endmodule