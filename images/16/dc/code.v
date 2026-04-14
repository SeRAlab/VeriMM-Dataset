module SR_flip_flop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q,
    output reg Qn
);
    always @(posedge clk) begin
        if (S && R) begin
            // Invalid state
            Q <= 1'bz; // High impedance or can be set to a specific value as needed
            Qn <= 1'bz; // High impedance or can be set to a specific value as needed
        end else if (S) begin
            Q <= 1'b1;  // Set Q
            Qn <= 1'b0; // Reset Qn
        end else if (R) begin
            Q <= 1'b0;  // Reset Q
            Qn <= 1'b1; // Set Qn
        end
    end
endmodule