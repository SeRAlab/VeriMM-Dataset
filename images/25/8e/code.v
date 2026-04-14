module JK_latch (
    input J,
    input K,
    input clk,
    output reg Q
);
    always @(posedge clk) begin
        if (J && !K) Q <= 1;   // Set
        else if (!J && K) Q <= 0; // Reset
        // If J and K are both low, Q remains unchanged
    end
endmodule