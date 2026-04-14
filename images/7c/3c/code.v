module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] SUM,
    output reg CARRY
);reg [3:0] temp_SUM;
reg [3:0] temp_CARRY;

// Stage 1
assign temp_SUM[0] = A[0] ^ B[0];
assign temp_CARRY[0] = A[0] & B[0];

// Stage 2
assign temp_SUM[1] = A[1] ^ B[1] ^ temp_CARRY[0];
assign temp_CARRY[1] = (A[1] & B[1]) | (temp_CARRY[0] & (A[1] ^ B[1]));

// Stage 3
assign temp_SUM[2] = A[2] ^ B[2] ^ temp_CARRY[1];
assign temp_CARRY[2] = (A[2] & B[2]) | (temp_CARRY[1] & (A[2] ^ B[2]));

// Stage 4
assign temp_SUM[3] = A[3] ^ B[3] ^ temp_CARRY[2];
assign CARRY = (A[3] & B[3]) | (temp_CARRY[2] & (A[3] ^ B[3]));
assign SUM = temp_SUM;

endmodule