module crc16_generator (
    input clk,
    input [15:0] data_in,
    input start,
    output reg [15:0] crc_out
);
    reg [15:0] crc;
    reg [15:0] polynomial = 16'hA001; // CRC polynomial x^16 + x^12 + x^5 + 1
    integer i;

    always @(posedge clk) begin
        if (start) begin
            crc <= 16'hFFFF; // Initialize CRC to all 1s
            for (i = 0; i < 16; i = i + 1) begin
                crc[15] = crc[15] ^ data_in[i];
                if (crc[15] == 1'b1) begin
                    crc = (crc << 1) ^ polynomial;
                end else begin
                    crc = crc << 1;
                end
            end
            crc_out <= crc; // Assign computed CRC to output
        end
    end
endmodule