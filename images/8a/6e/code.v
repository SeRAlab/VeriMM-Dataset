module top_module(
    input  [3:0] A,
    output [3:0] Y
);// Local signals
    wire [3:0] not_A;

    // Complement A using NOT gates
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin: not_gate
            not not0 (not_A[i], A[i]);
        end
    endgenerate

    // Output the complement
    assign Y = not_A;

endmodule