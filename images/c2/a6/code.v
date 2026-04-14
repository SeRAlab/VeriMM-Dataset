module adder4(
    input [3:0] A,
    input [3:0] B,
    output [3:0] S,
    output COUT
);

wire [3:0] sum;
wire carry;

assign sum = A + B;
assign COUT = (sum[4] == 1);

assign S = sum[3:0];

endmodule