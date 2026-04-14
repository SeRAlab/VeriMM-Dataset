module crc_generator(
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    input wire data_valid,
    output reg [7:0] crc_out
);
    reg [7:0] crc;
    integer bit_idx;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            crc <= 8'b0;
            bit_idx <= 0;
            crc_out <= 8'b0;
        end else if (data_valid) begin
            if (bit_idx < 8) begin
                crc[7] <= data_in[bit_idx] ^ crc[0];
                crc[6] <= crc[7];
                crc[5] <= crc[6];
                crc[4] <= crc[5];
                crc[3] <= crc[4];
                crc[2] <= crc[3] ^ data_in[bit_idx];
                crc[1] <= crc[2];
                crc[0] <= crc[1];
                bit_idx <= bit_idx + 1;
            end else begin
                crc_out <= crc;
                bit_idx <= 0; // Reset for next input
            end
        end
    end
endmodule