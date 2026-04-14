module D_latch (
    input wire D,
    input wire E,
    output reg Q
);
    always @ (E or D) begin
        if (E) begin
            Q <= D;
        end
    end
endmodule