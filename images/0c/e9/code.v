module D_latch (
    input wire D,
    input wire EN,
    output reg Q,
    output wire Qn
);
    assign Qn = ~Q;

    always @(D, EN) begin
        if (EN) begin
            Q <= D;
        end
    end
endmodule