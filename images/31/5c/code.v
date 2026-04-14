module sr_latch (
    input wire S,
    input wire R,
    output reg Q,
    output reg Qn
);
    always @ (S or R) begin
        if (S && !R) begin
            Q <= 1'b1;
            Qn <= 1'b0;
        end else if (!S && R) begin
            Q <= 1'b0;
            Qn <= 1'b1;
        end else if (!S && !R) begin
            // Retain previous state
            Q <= Q;
            Qn <= Qn;
        end else begin
            // Invalid state when both S and R are high
            Q <= 1'bx;
            Qn <= 1'bx;
        end
    end
endmodule