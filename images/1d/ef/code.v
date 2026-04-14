module SR_latch (
    input wire S,
    input wire R,
    output reg Q,
    output reg Qn
);
    always @ (S, R) begin
        if (S && ~R) begin
            Q <= 1;
            Qn <= 0;
        end else if (~S && R) begin
            Q <= 0;
            Qn <= 1;
        end
        // Invalid state handling
        // Both S and R should not be high at the same time
    end
endmodule