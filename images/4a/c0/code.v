module top_module(
    input a,
    input b,
    input c,
    input d,
    input e,
    input f,
    input g,
    output x
);assign x = (a & b & c & d & e & f & g);

endmodule