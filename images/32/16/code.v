module sr_flip_flop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q
);

always @(posedge clk) begin
    if (S && R) begin
        Q <= 0;  // Undefined state resolved to 0
    end else if (S) begin
        Q <= 1;  // Set state
    end else if (R) begin
        Q <= 0;  // Reset state
    end
    // If both are low, Q retains its previous value
end

endmodule