module crc_generator (
    input clk,
    input rst,
    input [15:0] data_in,
    input start,
    output reg [15:0] crc_out,
    output reg done
);

    reg [15:0] crc;
    reg [4:0] bit_count;

    parameter POLYNOMIAL = 16'hA001; // Example polynomial

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            crc <= 16'hFFFF; // Initial value
            bit_count <= 0;
            done <= 0;
        end else if (start) begin
            crc <= 16'hFFFF; // Reset CRC value
            bit_count <= 0;
            done <= 0;
        end else if (bit_count < 16) begin
            crc[15] = data_in[15 - bit_count] ^ crc[15];
            if (crc[15]) begin
                crc <= {crc[14:0], 1'b0} ^ POLYNOMIAL;
            end else begin
                crc <= {crc[14:0], 1'b0};
            end
            bit_count <= bit_count + 1;
        end else begin
            crc_out <= crc;
            done <= 1;
        end
    end
endmodule