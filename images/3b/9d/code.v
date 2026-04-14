module WallaceTreeMultiplier (
    input [3:0] A,
    input [3:0] B,
    output [7:0] P
);
    wire [3:0] pp0, pp1, pp2, pp3;
    wire [7:0] stage1, stage2;

    assign pp0 = A & {4{B[0]}};
    assign pp1 = A & {4{B[1]}};
    assign pp2 = A & {4{B[2]}};
    assign pp3 = A & {4{B[3]}};

    // Stage 1: Align partial products
    assign stage1 = {4'b0, pp0} + {3'b0, pp1, 1'b0} + {2'b0, pp2, 2'b00} + {1'b0, pp3, 3'b000};

    // Stage 2: Final addition of the aligned partial products
    assign P = stage1;

endmodule