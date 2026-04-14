module JK_latch (
    input J,
    input K,
    input clk,
    output reg Q
);
    always @(posedge clk) begin
        if (J && ~K)
            Q <= 1;        // Set
        else if (~J && K)
            Q <= 0;        // Reset
        else if (J && K)
            Q <= ~Q;       // Toggle
        // When J=0 and K=0, Q retains its value (hold)
    end
endmodule