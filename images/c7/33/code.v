module eight_bit_adder(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] s,
    output cout
);

assign {cout, s} = a + b + cin;

endmodule