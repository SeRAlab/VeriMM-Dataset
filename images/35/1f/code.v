module wallace_tree_adder(
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    output [4:0] sum
);
    wire [3:0] p0, p1, p2, p3;
    wire [4:0] s1, s2, s3;

    // Partial products
    assign p0 = a & {4{b[0]}};
    assign p1 = a & {4{b[1]}};
    assign p2 = a & {4{b[2]}};
    assign p3 = a & {4{b[3]}};

    // First stage of addition using full adders
    wire [4:0] fa1_out;
    assign fa1_out = p0 + p1 + p2;

    // Second stage of addition using full adders
    assign s1 = fa1_out + p3;

    // Final stage to produce the sum
    assign sum = s1;

endmodule