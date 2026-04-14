module top_module(
    input OP_A,
    input OP_B,
    output SUM,
    output CO
    );assign SUM = OP_A^OP_B ;
    assign CO = OP_A & OP_B ;
endmodule