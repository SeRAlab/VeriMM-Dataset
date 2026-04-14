module binary_counter_2bit(
    input clk,
    input reset,
    input enable,
    output reg [1:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the counter to zero
            q <= 2'b00;
        end else if (enable) begin
            // Increment the counter by 1
            q <= q + 1;
        end
    end

endmodule