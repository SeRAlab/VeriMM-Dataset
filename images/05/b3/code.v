module sr_latch (
    input wire S,
    input wire R,
    output reg Q
);
    always @(S or R) begin
        if (S && R) begin
            Q <= 1'bx; // Invalid state
        end else if (S) begin
            Q <= 1'b1; // Set
        end else if (R) begin
            Q <= 1'b0; // Reset
        end
        // If both S and R are low, retain previous state
    end
endmodule