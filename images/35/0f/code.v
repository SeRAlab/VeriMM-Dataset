module crc_generator (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [15:0] data_in,
    output reg [15:0] crc_out,
    output reg done
);
    reg [15:0] crc;
    reg [4:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc <= 16'b0;
            crc_out <= 16'b0;
            done <= 0;
            bit_count <= 0;
        end else if (start) begin
            // Initialize CRC and bit count
            crc <= 16'b0;
            bit_count <= 0;
            done <= 0;
        end else if (bit_count < 16) begin
            // Update CRC based on input data
            crc <= (crc << 1) ^ ((crc[15] ^ data_in[bit_count]) ? 16'hA001 : 16'h0);
            bit_count <= bit_count + 1;
        end else begin
            // Output the CRC and signal done
            crc_out <= crc;
            done <= 1;
        end
    end
endmodule