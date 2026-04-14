module top_module(
    input A0,
    input A1,
    input A2,
    input A3,
    input S0,
    input S1,
    output X
);wire notS0;
wire notS1;
wire and1;
wire and2;
wire and3;
wire and4;
wire or1;

not(notS0, S0);
not(notS1, S1);

and(and1, A0, notS0, notS1);
and(and2, A1, notS0, S1);
and(and3, A2, S0, notS1);
and(and4, A3, S0, S1);

or(or1, and1, and2, and3, and4);

assign X = or1;

endmodule