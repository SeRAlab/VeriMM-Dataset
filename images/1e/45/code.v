module sr_latch (
    input wire S,
    input wire R,
    output reg Q,
    output reg Qn
);
    always @ (S or R) begin
        if (S && R) begin
            // Invalid state, keep previous state
            Q <= Q;
            Qn <= ~Q; // Not changing the output
        end else if (S) begin
            Q <= 1'b1;
            Qn <= 1'b0;
        end else if (R) begin
            Q <= 1'b0;
            Qn <= 1'b1;
        end
    end
endmodule