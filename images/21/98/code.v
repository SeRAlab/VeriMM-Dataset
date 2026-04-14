module sr_flip_flop (
    input wire S,
    input wire R,
    input wire CLK,
    output reg Q
);

always @(posedge CLK) begin
    if (S && !R) Q <= 1;       // Set
    else if (!S && R) Q <= 0;  // Reset
    // If both S and R are low, do nothing (hold state)
end

endmodule