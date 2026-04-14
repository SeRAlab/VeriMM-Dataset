module JK_latch (
    input J,
    input K,
    input CLK,
    output reg Q
);
    always @(posedge CLK) begin
        if (J == 1 && K == 1)
            Q <= ~Q; // Toggle
        else if (J == 1 && K == 0)
            Q <= 1;   // Set
        else if (J == 0 && K == 1)
            Q <= 0;   // Reset
        // If J == 0 and K == 0, Q remains unchanged
    end
endmodule