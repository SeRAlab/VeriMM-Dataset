module sr_latch (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (S && R) begin
            // Invalid state handling (both Set and Reset active)
            Q <= 1'bx; // Undefined state
        end else if (S) begin
            Q <= 1'b1; // Set
        end else if (R) begin
            Q <= 1'b0; // Reset
        end
        // If neither S nor R is active, retain previous value of Q
    end
endmodule