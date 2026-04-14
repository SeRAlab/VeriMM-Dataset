module SR_FlipFlop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (S && R) begin
            // Invalid state, keep Q unchanged
        end else if (S) begin
            Q <= 1'b1; // Set
        end else if (R) begin
            Q <= 1'b0; // Reset
        end
        // If S and R are both low, maintain the current output
    end
endmodule