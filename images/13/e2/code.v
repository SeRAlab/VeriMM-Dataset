module SR_latch (
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
        end
        // If both S and R are low, keep the previous state
    end
endmodule