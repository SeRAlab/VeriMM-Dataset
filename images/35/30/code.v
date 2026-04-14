module wallace_tree_adder(
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    output [6:0] sum
);
    wire [5:0] stage1 [0:2];
    wire [5:0] stage2;

    // First stage of addition
    assign stage1[0] = {1'b0, a} + {1'b0, b};
    assign stage1[1] = stage1[0] + {1'b0, c};
    
    // Final output
    assign sum = stage1[1];

endmodule