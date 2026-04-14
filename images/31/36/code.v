module hamming_encoder (
    input [7:0] data_in,
    output reg [11:0] codeword
);

    always @(*) begin
        codeword[2] = data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[6]; // parity bit 1
        codeword[4] = data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[6]; // parity bit 2
        codeword[8] = data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[7]; // parity bit 4
        codeword[10] = data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7]; // parity bit 8

        // Fill in data bits
        codeword[0] = data_in[0];
        codeword[1] = data_in[1];
        codeword[3] = data_in[2];
        codeword[5] = data_in[3];
        codeword[6] = data_in[4];
        codeword[7] = data_in[5];
        codeword[9] = data_in[6];
        codeword[11] = data_in[7];
    end
endmodule