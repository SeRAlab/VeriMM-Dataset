module wallace_tree_multiplier (
    input [3:0] a,
    input [3:0] b,
    output [7:0] product
);
    wire [3:0] pp0, pp1, pp2, pp3;
    wire [7:0] p0, p1, p2, p3;

    // Generate partial products
    assign pp0 = a[0] ? b : 4'b0000;
    assign pp1 = a[1] ? {b, 1'b0} : 5'b00000;
    assign pp2 = a[2] ? {b, 2'b00} : 6'b000000;
    assign pp3 = a[3] ? {b, 3'b000} : 7'b0000000;

    // Sum partial products
    assign product = pp0 + pp1 + pp2 + pp3;

endmodule