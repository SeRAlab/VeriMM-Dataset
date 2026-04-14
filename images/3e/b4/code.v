module crc8_generator (
    input wire [7:0] data_in,
    input wire start,
    input wire clk,
    input wire rst,
    output reg [7:0] crc_out,
    output reg crc_valid
);
    reg [7:0] crc;
    reg [3:0] bit_count;
    reg processing;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            crc <= 8'h00;
            crc_out <= 8'h00;
            crc_valid <= 0;
            bit_count <= 0;
            processing <= 0;
        end else if (start && !processing) begin
            crc <= 8'h00;
            bit_count <= 8;
            processing <= 1;
            crc_valid <= 0;
        end else if (processing) begin
            if (bit_count > 0) begin
                crc <= {crc[6:0], 1'b0} ^ (crc[7] ? 8'h1D : 8'h00); // CRC polynomial x^8 + x^7 + x^4 + 1
                crc[0] <= crc[0] ^ data_in[bit_count - 1];
                bit_count <= bit_count - 1;
            end else begin
                crc_out <= crc;
                crc_valid <= 1;
                processing <= 0;
            end
        end
    end
endmodule