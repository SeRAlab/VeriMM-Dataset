module D_latch (
    input D,
    input EN,
    output reg Q
);
    always @(D or EN) begin
        if (EN) begin
            Q <= D; // Update Q with D when EN is high
        end
        // When EN is low, Q retains its previous value
    end
endmodule