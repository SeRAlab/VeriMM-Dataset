module four_bit_adder(
    input [3:0] A,
    input [3:0] B,
    input C_in,
    output [3:0] S,
    output C_out
);

wire [3:0] sum;
wire [4:0] carry;

assign sum[0] = A[0] ^ B[0] ^ C_in;
assign carry[1] = (A[0] & B[0]) | (A[0] & C_in) | (B[0] & C_in);
assign sum[1] = A[1] ^ B[1] ^ carry[1];
assign carry[2] = (A[1] & B[1]) | (A[1] & carry[1]) | (B[1] & carry[1]);
assign sum[2] = A[2] ^ B[2] ^ carry[2];
assign carry[3] = (A[2] & B[2]) | (A[2] & carry[2]) | (B[2] & carry[2]);
assign sum[3] = A[3] ^ B[3] ^ carry[3];
assign C_out = carry[4];

assign S = sum;

endmodule