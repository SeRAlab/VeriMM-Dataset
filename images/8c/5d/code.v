module top_module(
    input in1,
    input in2,
    input in3,
    output out
);wire n1, n2;
assign n1 = ~in1;
assign n2 = ~in2;

assign out = ~(n1 & n2 & ~in3);

endmodule