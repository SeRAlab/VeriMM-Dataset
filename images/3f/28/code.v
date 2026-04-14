module D_latch (
    input wire D,
    input wire E,
    output reg Q,
    output reg Qn
);
    always @(E or D) begin
        if (E) begin
            Q <= D;
        end
        Qn <= ~Q;
    end
endmodule