module SR_FlipFlop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q,
    output reg Qn
);
    always @(posedge clk) begin
        if (S && R) begin
            // Invalid state
            Q <= 1'bx; // Indeterminate state
            Qn <= 1'bx; // Indeterminate state
        end else if (S) begin
            Q <= 1;
            Qn <= 0;
        end else if (R) begin
            Q <= 0;
            Qn <= 1;
        end
        // Maintain state when both S and R are low
    end
endmodule