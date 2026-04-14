module JK_latch (
    input J,
    input K,
    input CLK,
    output reg Q
);
    always @(posedge CLK) begin
        if (J == 0 && K == 0) begin
            // Do nothing, keep current state
        end else if (J == 1 && K == 0) begin
            Q <= 1;  // Set
        end else if (J == 0 && K == 1) begin
            Q <= 0;  // Reset
        end else if (J == 1 && K == 1) begin
            Q <= ~Q; // Toggle
        end
    end
endmodule