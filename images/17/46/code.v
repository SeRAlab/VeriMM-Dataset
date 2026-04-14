module D_latch (
    input D,
    input C,
    output reg Q
);
    always @ (D or C) begin
        if (C) begin
            Q <= D;
        end
    end
endmodule