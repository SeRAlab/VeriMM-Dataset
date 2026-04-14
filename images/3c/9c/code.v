module SR_FlipFlop (
    input wire S,
    input wire R,
    input wire CLK,
    output reg Q
);

always @(posedge CLK) begin
    if (R) 
        Q <= 0; // Reset state
    else if (S) 
        Q <= 1; // Set state
    // If both S and R are low, Q retains its state.
end

endmodule