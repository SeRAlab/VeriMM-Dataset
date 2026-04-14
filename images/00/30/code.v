module JK_latch (
    input wire J,
    input wire K,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (J && K) 
            Q <= ~Q;      // Toggle
        else if (J) 
            Q <= 1'b1;    // Set
        else if (K) 
            Q <= 1'b0;    // Reset
        // If both J and K are low, Q remains unchanged
    end
endmodule