module JK_latch (
    input J,
    input K,
    input Clock,
    output reg Q
);
    always @(posedge Clock) begin
        if (J && K) Q <= ~Q; // Toggle
        else if (J) Q <= 1;  // Set
        else if (K) Q <= 0;  // Reset
        // if (J == 0 && K == 0) Q retains its value
    end
endmodule