module hamming_encoder (
    input [3:0] data,
    output [6:0] encoded
);
    wire p1, p2, p3;

    // Parity bits calculations
    assign p1 = data[0] ^ data[1] ^ data[3]; // Check bits for d1, d2, d4
    assign p2 = data[0] ^ data[2] ^ data[3]; // Check bits for d1, d3, d4
    assign p3 = data[1] ^ data[2] ^ data[3]; // Check bits for d2, d3, d4

    // Constructing the encoded output
    assign encoded[6] = p3; // Parity bit 1
    assign encoded[5] = p2; // Parity bit 2
    assign encoded[4] = p1; // Parity bit 3
    assign encoded[3] = data[0]; // Data bit 1
    assign encoded[2] = data[1]; // Data bit 2
    assign encoded[1] = data[2]; // Data bit 3
    assign encoded[0] = data[3]; // Data bit 4
endmodule