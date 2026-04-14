module D_latch (
    input wire D,
    input wire EN,
    output reg Q
);
    always @ (D or EN) begin
        if (EN) begin
            Q <= D;  // Update Q when EN is high
        end
        // When EN is low, Q holds its previous value
    end
endmodule