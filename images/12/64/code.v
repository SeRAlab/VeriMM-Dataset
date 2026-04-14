module SR_latch(
    input S,
    input R,
    output reg Q,
    output reg Qn
);
    always @(S or R) begin
        if (S && !R) begin
            Q <= 1;
            Qn <= 0;
        end else if (!S && R) begin
            Q <= 0;
            Qn <= 1;
        end else if (S && R) begin
            // Invalid condition, hold previous state
            Q <= Q;
            Qn <= Qn;
        end
    end
endmodule