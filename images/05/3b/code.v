module crc32(input clk, input reset, input [7:0] data_in, input data_valid, output reg [31:0] crc_out);
    reg [31:0] crc;
    reg [7:0] polynomial = 8'h04C11DB7; // CRC polynomial in binary representation

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc <= 32'hFFFFFFFF; // Initial value for CRC-32
        end else if (data_valid) begin
            crc <= (crc >> 8) ^ polynomial[(crc ^ data_in) & 8'hFF];
        end
    end

    always @(posedge clk) begin
        if (data_valid) begin
            crc_out <= crc;
        end
    end
endmodule