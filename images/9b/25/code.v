module top_module(
    input a,
    input b,
    input c,
    output reg out
);wire nand1_out;
    wire nand2_out;
    wire nand3_out;

    // AND gate behavioral model
    assign nand1_out = ~(a & b);

    // 2-input XOR gate designed using only NAND gates
    assign nand2_out = ~(a & ~(c));
    assign nand3_out = ~(~(c) & b);
    assign out = ~(nand2_out & nand3_out);

endmodule