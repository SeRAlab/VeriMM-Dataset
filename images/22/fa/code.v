module SR_latch(
    input wire S,
    input wire R,
    input wire CLK,
    output reg Q
);
    always @(posedge CLK) begin
        if (S && ~R) begin
            Q <= 1'b1; // Set
        end else if (~S && R) begin
            Q <= 1'b0; // Reset
        end
        // If both S and R are low, maintain the previous state
    end
endmodule