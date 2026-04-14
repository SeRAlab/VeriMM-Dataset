module binary_counter(
    input clk,
    input reset,
    input enable,
    output reg [1:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset
            q <= 2'b00;
        end else if (enable) begin
            // Increment the counter when enabled
            q <= q + 1;
        end
    end

endmodule