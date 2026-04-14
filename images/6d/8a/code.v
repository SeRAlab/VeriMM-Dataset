module top_module(
    input in1,
    input in2,
    input in3,
    input in4,
    output out
);wire and1, and2, and3;

and u1(and1, in1, in2);
and u2(and2, in3, in4);
and u3(and3, and1, and2);
assign out = and3;

endmodule