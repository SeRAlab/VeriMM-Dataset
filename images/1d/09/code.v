module sr_latch (
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
        end else if (!S && !R) begin
            // hold state
            Q <= Q;
            Qn <= Qn;
        end else begin
            // invalid state
            Q <= 1'bx;
            Qn <= 1'bx;
        end
    end
endmodule