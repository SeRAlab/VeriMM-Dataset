module hamming_encoder (
    input [15:0] data_in,
    output reg [20:0] code_out
);
    integer i;
    reg [20:0] temp;

    always @(*) begin
        // Initialize the code_out with input data
        temp = 0;
        temp[0] = data_in[0];
        temp[1] = data_in[1];
        temp[2] = data_in[2];
        temp[3] = data_in[3];
        temp[4] = data_in[4];
        temp[5] = data_in[5];
        temp[6] = data_in[6];
        temp[7] = data_in[7];
        temp[8] = data_in[8];
        temp[9] = data_in[9];
        temp[10] = data_in[10];
        temp[11] = data_in[11];
        temp[12] = data_in[12];
        temp[13] = data_in[13];
        temp[14] = data_in[14];
        temp[15] = data_in[15];

        // Calculate parity bits
        temp[16] = temp[0] ^ temp[2] ^ temp[4] ^ temp[6] ^ temp[8] ^ temp[10] ^ temp[12] ^ temp[14]; // P1
        temp[17] = temp[1] ^ temp[2] ^ temp[5] ^ temp[6] ^ temp[9] ^ temp[10] ^ temp[13] ^ temp[14]; // P2
        temp[18] = temp[3] ^ temp[4] ^ temp[5] ^ temp[6] ^ temp[11] ^ temp[12] ^ temp[13] ^ temp[14]; // P4
        temp[19] = temp[7] ^ temp[8] ^ temp[9] ^ temp[10] ^ temp[11] ^ temp[12] ^ temp[13] ^ temp[14]; // P8
        temp[20] = temp[15]; // P16 (just take the last bit for this case)

        // Assign the correct positions to code_out
        code_out = {temp[20], temp[19], temp[18], temp[17], temp[16], temp[15], temp[14], temp[13],
                    temp[12], temp[11], temp[10], temp[9], temp[8], temp[7], temp[6], temp[5],
                    temp[4], temp[3], temp[2], temp[1], temp[0]};
    end
endmodule