module counter(
    input clk,
    input clear,
    input enable,
    output reg [3:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (clear) begin
            q <= 4'd0;  // Synchronous clear to zero
        end else if (enable) begin
            q <= q + 1;  // Increment counter by 1
        end
    end

endmodule