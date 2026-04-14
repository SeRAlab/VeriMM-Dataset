module top_module (
    input [3:1] b,
    input j,
    output reg B2,
    output reg B3
);

    always @(*) begin
        // B2 corresponds to the transition to state B
        B2 = (b[1] & ~j) | (b[3] & ~j);

        // B3 corresponds to the transition to state C
        B3 = (b[1] & j) | (b[2] & j);
    end

endmodule