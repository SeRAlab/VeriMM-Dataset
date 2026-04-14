module sr_latch (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (S && R) begin
            // Invalid state
            Q <= Q; // Retain previous state
        end else if (S) begin
            Q <= 1'b1; // Set state
        end else if (R) begin
            Q <= 1'b0; // Reset state
        end
        // If both S and R are low, do nothing (retain current state)
    end
endmodule