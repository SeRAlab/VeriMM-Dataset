module full_adder_2bit(
    input [1:0] a,
    input [1:0] b,
    input cin,
    output [1:0] sum,
    output cout
);

wire c1;

assign {c1, sum[0]} = a[0] + b[0] + cin;
assign {cout, sum[1]} = a[1] + b[1] + c1;

endmodule