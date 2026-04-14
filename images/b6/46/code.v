module top_module(
    in0,
    in1,
    sel,
    out
);input in0;
input in1;
input sel;
output out;

assign out = sel ? in1 : in0;

endmodule