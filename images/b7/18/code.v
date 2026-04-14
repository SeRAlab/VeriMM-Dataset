module full_adder_2bit(
    input [1:0] a,
    input [1:0] b,
    input cin,
    output [1:0] sum,
    output cout
);
    assign {cout, sum} = a + b + cin;
endmodule