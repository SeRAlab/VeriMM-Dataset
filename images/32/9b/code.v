module crc_generator (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [15:0] data_in,
    output reg [15:0] crc_out
);
    reg [15:0] crc;
    reg [3:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc <= 16'h0000;
            bit_count <= 4'd0;
            crc_out <= 16'h0000;
        end else if (start) begin
            crc <= 16'h0000; // Reset CRC for new calculation
            bit_count <= 4'd0;
        end else if (bit_count < 16) begin
            crc[15] <= (crc[14] ^ data_in[bit_count]) ^ (crc[0] & (crc[15] ^ crc[12] ^ crc[5]));
            crc <= {crc[14:0], 1'b0}; // Shift left
            bit_count <= bit_count + 1;
        end else begin
            crc_out <= crc; // Output final CRC after 16 bits processed
        end
    end
endmodule