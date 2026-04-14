module counter(
    input clk,
    input reset,
    input mode,
    output reg [15:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;  // Synchronous reset to zero
        end else if (mode) begin
            q <= q + 1;  // Count up
        end else begin
            q <= q - 1;  // Count down
        end
    end

endmodule