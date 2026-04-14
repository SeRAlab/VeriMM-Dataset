module top_module(
    input in1,
    input in2,
    input en,
    output out
);assign out = (en == 1'b1) ? (in1 & in2) : 1'b0;

endmodule