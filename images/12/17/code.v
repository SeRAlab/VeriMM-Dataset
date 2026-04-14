module SR_Latch(
    input S,
    input R,
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
            // Maintain previous state
            Q <= Q;
            Qn <= Qn;
        end else begin
            // Invalid state: both S and R should not be high
            // You can choose to handle this case as desired
        end
    end
endmodule