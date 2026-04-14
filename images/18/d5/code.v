module sr_flip_flop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (S && R) begin
            // Invalid state, do nothing
        end else if (S) begin
            Q <= 1'b1; // Set
        end else if (R) begin
            Q <= 1'b0; // Reset
        end
        // If both S and R are low, maintain the current state (hold)
    end
endmodule