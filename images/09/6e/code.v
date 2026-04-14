module JK_latch (
    input wire J,
    input wire K,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (J && !K) 
            Q <= 1; // Set
        else if (!J && K) 
            Q <= 0; // Reset
        else if (J && K) 
            Q <= ~Q; // Toggle
        // If J = 0 and K = 0, Q retains its previous state
    end
endmodule