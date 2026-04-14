module D_latch (
    input wire D,
    input wire EN,
    output reg Q
);
    always @(D, EN) begin
        if (EN) begin
            Q <= D;
        end
    end
endmodule