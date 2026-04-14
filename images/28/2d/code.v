module wallace_tree_adder(
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    output [7:0] sum
);
    wire [7:0] p0, p1, p2, p3;
    wire [3:0] s1, c1, s2, c2;

    // Partial products
    assign p0 = {4'b0000, a} + {4'b0000, b};
    assign p1 = {4'b0000, c} + {4'b0000, d};

    // First stage of addition
    assign {c1, s1} = p0 + p1;

    // Second stage of addition
    assign p2 = {4'b0000, s1} + {4'b0000, c1};

    // Final sum
    assign sum = p2;

endmodule