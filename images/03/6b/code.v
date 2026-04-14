module JK_latch(
    input J,
    input K,
    input clk,
    output reg Q
);
    always @(posedge clk) begin
        if (J && !K) begin
            Q <= 1'b1; // Set
        end else if (!J && K) begin
            Q <= 1'b0; // Reset
        end else if (J && K) begin
            Q <= ~Q;   // Toggle
        end
        // If J and K are both low, Q remains unchanged
    end
endmodule