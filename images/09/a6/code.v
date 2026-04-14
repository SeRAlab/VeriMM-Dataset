module d_latch (
    input wire D,
    input wire EN,
    output reg Q
);
    always @(*) begin
        if (EN)
            Q <= D;
    end
endmodule