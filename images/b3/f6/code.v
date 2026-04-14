module top_module(
    input a,
    input b,
    input c,
    output true_val,
    output false_val,
    output and1,
    output and2,
    output and3,
    output or1,
    output or2,
    output or3,
    output not1,
    output not2
);assign true_val = 1'b1;
assign false_val = 1'b0;
assign and1 = a & b & c;
assign and2 = a & b;
assign and3 = a & c;
assign or1 = a | b | c;
assign or2 = a | b;
assign or3 = a | c;
assign not1 = !a;
assign not2 = !b;

endmodule