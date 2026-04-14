module top_module(
    input clk,
    input reset,
    input enable,
    output reg [3:0] q,
    output carry
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the counter to 4'b0000
            q <= 4'b0000;
        end else if (enable) begin
            // Counter increments when enabled
            q <= q + 1;
        end
    end
    
    // Carry-out when counter overflows
    assign carry = enable & (q == 4'b1111);

endmodule