module sr_latch (
    input S,
    input R,
    output reg Q,
    output reg Qn
);
    always @ (S or R) begin
        if (S && !R) begin
            Q = 1'b1;
            Qn = 1'b0;
        end else if (!S && R) begin
            Q = 1'b0;
            Qn = 1'b1;
        end else if (!S && !R) begin
            // hold state
        end else begin
            // invalid state, can be set to Q = 1'bx, Qn = 1'bx
        end
    end
endmodule