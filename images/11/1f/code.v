module crc_generator (
    input wire clk,
    input wire reset,
    input wire data_in,
    input wire data_valid,
    output reg [15:0] crc_out
);
    reg [15:0] crc;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc <= 16'hFFFF; // Initialize CRC to all 1s
        end else if (data_valid) begin
            crc[0] <= crc[0] ^ data_in;
            crc[1] <= crc[1] ^ crc[0];
            crc[2] <= crc[2] ^ crc[1];
            crc[3] <= crc[3] ^ crc[2];
            crc[4] <= crc[4] ^ crc[3];
            crc[5] <= crc[5] ^ crc[4];
            crc[6] <= crc[6] ^ crc[5];
            crc[7] <= crc[7] ^ crc[6];
            crc[8] <= crc[8] ^ crc[7] ^ data_in;
            crc[9] <= crc[9] ^ crc[8];
            crc[10] <= crc[10] ^ crc[9];
            crc[11] <= crc[11] ^ crc[10];
            crc[12] <= crc[12] ^ crc[11];
            crc[13] <= crc[13] ^ crc[12];
            crc[14] <= crc[14] ^ crc[13];
            crc[15] <= crc[15] ^ crc[14];
        end
    end

    always @(posedge clk) begin
        crc_out <= crc; // Output the current CRC value
    end
endmodule