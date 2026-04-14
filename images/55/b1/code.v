module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);wire [3:0] sum;
    wire c1, c2, c3;

    // Use a behavioral or structural equivalent for the full adder if the module is unknown
    assign {Cout, sum} = A + B + Cin;

    assign S = sum;

endmodule