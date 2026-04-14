module counter(
    input clk,
    input reset,
    input enable,
    output reg [3:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd0;  // Synchronous reset to zero
        end else if (enable) begin
            q <= q + 1;  // Increment counter by 1
        end
    end

endmodule