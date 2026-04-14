module top_module(
    input [3:0] A,
    input [3:0] B,
    output [3:0] OUT
);reg [3:0] sum [0:1];
reg [3:0] carry [0:2];

// First stage
assign sum[0] = A + B;
assign carry[0] = A[0] & B[0];

// Second stage
assign sum[1] = sum[0] + carry[0];
assign carry[1] = sum[0][1] & carry[0];

// Third stage
assign OUT = sum[1] + carry[1];
assign carry[2] = sum[1][2] & carry[1];

// Fourth stage
assign OUT = OUT + carry[2];

endmodule