module hamming_encoder (
    input [3:0] data_in,
    output [6:0] encoded_out
);
    wire p1, p2, p3;

    // Parity bit calculations
    assign p1 = data_in[0] ^ data_in[1] ^ data_in[3]; // parity for bits 1, 2, 4
    assign p2 = data_in[0] ^ data_in[2] ^ data_in[3]; // parity for bits 1, 3, 4
    assign p3 = data_in[1] ^ data_in[2] ^ data_in[3]; // parity for bits 2, 3, 4

    assign encoded_out = {p3, p2, data_in[2], p1, data_in[1:0]};
endmodule