module sr_latch (
    input wire S,
    input wire R,
    output reg Q,
    output reg Qn
);
    always @(S, R) begin
        if (S && !R) begin
            Q <= 1;
            Qn <= 0;
        end else if (!S && R) begin
            Q <= 0;
            Qn <= 1;
        end else if (!S && !R) begin
            // Hold state (no change)
            Q <= Q;
            Qn <= Qn;
        end else begin
            // Invalid state
            Q <= 1'bz; // High impedance
            Qn <= 1'bz; // High impedance
        end
    end
endmodule