module SR_FF (
    input S,
    input R,
    input clk,
    output reg Q
);

always @(posedge clk) begin
    if (S && R) begin
        // Undefined state
    end else if (S) begin
        Q <= 1'b1; // Set state
    end else if (R) begin
        Q <= 1'b0; // Reset state
    end
    // Q retains its state when both S and R are low
end

endmodule