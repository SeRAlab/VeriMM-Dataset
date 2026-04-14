module crc_4bit (
    input wire clk,
    input wire rst,
    input wire [3:0] data_in,
    output reg [3:0] crc_out
);
    reg [4:0] crc;  // 4-bit CRC + 1-bit for carry

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            crc <= 5'b00000;  // Reset CRC
        end else begin
            crc[4] <= data_in[0] ^ crc[4];  // XOR with input bit
            crc[3] <= data_in[1] ^ crc[4] ^ crc[3]; // Polynomial division
            crc[2] <= data_in[2] ^ crc[3] ^ crc[2];
            crc[1] <= data_in[3] ^ crc[2] ^ crc[1];
            crc[0] <= crc[1]; // Shifting in the CRC
            crc_out <= crc[4:1]; // Output the CRC (4 bits)
        end
    end
endmodule