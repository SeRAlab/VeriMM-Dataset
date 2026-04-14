module four_bit_adder (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);

wire [3:0] c;
assign c[0] = cin;
assign sum = a + b + c;
assign cout = (a[3] & b[3]) | (a[3] & c[0]) | (b[3] & c[0]);

endmodule