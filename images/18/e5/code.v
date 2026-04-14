module SR_FF (
    input wire S,
    input wire R,
    input wire C,
    output reg Q
);
    always @(posedge C) begin
        if (S && !R) begin
            Q <= 1'b1; // Set
        end else if (!S && R) begin
            Q <= 1'b0; // Reset
        end else if (S && R) begin
            // Invalid state, retain previous state
        end // else case: retain previous state
    end
endmodule