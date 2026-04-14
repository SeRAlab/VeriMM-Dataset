module D_latch (
    input wire D,
    input wire En,
    output reg Q
);
    always @(D or En) begin
        if (En) begin
            Q <= D;
        end
    end
endmodule