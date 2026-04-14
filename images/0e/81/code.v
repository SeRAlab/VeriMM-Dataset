module sr_latch (
    input wire clk,
    input wire S,
    input wire R,
    output reg Q
);

    always @(posedge clk) begin
        if (S && R) begin
            // Invalid state, hold previous value
            Q <= Q; 
        end else if (S) begin
            Q <= 1'b1; // Set
        end else if (R) begin
            Q <= 1'b0; // Reset
        end
        // If both S and R are low, do nothing (hold state)
    end
endmodule