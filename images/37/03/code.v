module hamming_encoder (
    input [3:0] data,
    output [6:0] code
);

wire p1, p2, p3, p4;

assign p1 = data[0] ^ data[1] ^ data[3]; // parity bit P1
assign p2 = data[0] ^ data[2] ^ data[3]; // parity bit P2
assign p3 = data[1] ^ data[2] ^ data[3]; // parity bit P3

assign code[6] = p1; // code bit 6
assign code[5] = p2; // code bit 5
assign code[4] = data[0]; // code bit 4
assign code[3] = p3; // code bit 3
assign code[2] = data[1]; // code bit 2
assign code[1] = data[2]; // code bit 1
assign code[0] = data[3]; // code bit 0

endmodule