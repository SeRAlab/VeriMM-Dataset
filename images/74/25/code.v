module binary_counter_with_enable
(
    input clk,
    input reset,
    input enable,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 8'b00000000; // Clear counter to 00000000
        end else if (enable) begin
            q <= q + 1; // Increment counter
        end
    end

endmodule