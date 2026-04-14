module sr_latch (
    input S,
    input R,
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
        end else if (S && R) begin
            // Invalid state for SR Latch
            Q <= 1'bx; // Indeterminate
            Qn <= 1'bx; // Indeterminate
        end
    end
endmodule