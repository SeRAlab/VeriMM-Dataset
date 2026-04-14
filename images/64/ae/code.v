module top_module(
    input clk,
    input reset,
    input enable,
    output reg [1:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 2'b00;  // Reset the counter to zero
        end else if (enable) begin
            q <= q + 1;  // Increment the counter if enabled
        end
    end

endmodule