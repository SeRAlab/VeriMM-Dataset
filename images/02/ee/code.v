module hamming_encoder (
    input [3:0] data,
    output reg [6:0] codeword
);
    always @(*) begin
        codeword[2:0] = data; // Data bits
        codeword[3] = data[0] ^ data[1] ^ data[3]; // Parity bit P1
        codeword[4] = data[0] ^ data[2] ^ data[3]; // Parity bit P2
        codeword[5] = data[1] ^ data[2] ^ data[3]; // Parity bit P3
        codeword[6] = data[0]; // Extra bit for redundancy
    end
endmodule