module top_module(
    input A1,
    input A2,
    input B1,
    output X,
    input VPWR,
    input VGND
);wire and1;
wire and2;

and and_gate1(and1, A1, A2);
and and_gate2(and2, and1, B1);
assign X = and2;

endmodule