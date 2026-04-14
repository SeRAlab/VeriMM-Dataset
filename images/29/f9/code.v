module SR_FlipFlop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q,
    output wire Qn
);
    assign Qn = ~Q;

    always @(posedge clk) begin
        if (S && ~R) begin
            Q <= 1; // Set
        end else if (~S && R) begin
            Q <= 0; // Reset
        end else if (S && R) begin
            // Invalid state (can be handled as per design choice)
        end
        // else case: do nothing (hold previous state)
    end
endmodule