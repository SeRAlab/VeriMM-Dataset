module crc_generator (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire data_valid,
    output reg [7:0] crc_out
);
    reg [7:0] crc;
    reg [3:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc <= 8'b0;
            crc_out <= 8'b0;
            bit_count <= 4'b0;
        end else if (data_valid) begin
            crc <= crc ^ data_in; // Initial CRC calculation
            for (bit_count = 0; bit_count < 8; bit_count = bit_count + 1) begin
                if (crc[7] == 1) begin
                    crc <= {crc[6:0], 1'b0} ^ 8'b11000011; // Polynomial x^8 + x^7 + x^4 + x^3 + x^2 + 1
                end else begin
                    crc <= {crc[6:0], 1'b0};
                end
            end
            crc_out <= crc;
        end
    end
endmodule