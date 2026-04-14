module SR_FF (
    input wire S,
    input wire R,
    input wire CLK,
    output reg Q
);
    always @(posedge CLK or posedge R) begin
        if (R) begin
            Q <= 0; // Reset state
        end else if (S) begin
            Q <= 1; // Set state
        end
        // If both S and R are high, Q remains unchanged
    end
endmodule