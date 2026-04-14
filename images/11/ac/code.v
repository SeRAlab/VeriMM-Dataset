module sr_flip_flop (
    input wire S,
    input wire R,
    input wire EN,
    output reg Q
);
    always @(posedge EN) begin
        if (S && !R) begin
            Q <= 1'b1; // Set
        end else if (!S && R) begin
            Q <= 1'b0; // Reset
        end
        // If both S and R are low, do nothing (hold state)
    end
endmodule