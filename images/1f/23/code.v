module SR_FlipFlop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q,
    output reg Qn
);
    always @(posedge clk) begin
        if (S && !R) begin
            Q <= 1'b1;
            Qn <= 1'b0;
        end else if (!S && R) begin
            Q <= 1'b0;
            Qn <= 1'b1;
        end else if (S && R) begin
            // Invalid condition, hold the previous state
            Q <= Q;
            Qn <= Qn;
        end
    end
endmodule