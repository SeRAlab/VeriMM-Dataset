module SR_FlipFlop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q,
    output reg Qn
);
    always @(posedge clk) begin
        if (S && ~R) begin
            Q <= 1;
            Qn <= 0;
        end else if (~S && R) begin
            Q <= 0;
            Qn <= 1;
        end else if (S && R) begin
            // Invalid state for SR flip-flop, can be handled as needed
            Q <= Q; // Maintain state
            Qn <= ~Q; // Complement of Q
        end
    end
endmodule