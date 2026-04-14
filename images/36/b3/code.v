module SR_latch (
    input S,
    input R,
    output reg Q,
    output reg Qn
);
    always @ (S or R) begin
        if (S && ~R) begin
            Q = 1;
            Qn = 0;
        end else if (~S && R) begin
            Q = 0;
            Qn = 1;
        end else if (~S && ~R) begin
            // Maintain state
            Q = Q;
            Qn = Qn;
        end else begin
            // Invalid state (S = 1 and R = 1), we can choose to do nothing or reset
            Q = 0;
            Qn = 1;
        end
    end
endmodule