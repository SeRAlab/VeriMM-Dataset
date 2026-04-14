module crc32_generator (
    input [31:0] data_in,
    output reg [31:0] crc_out
);
    
    // Polynomial representation - x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x + 1
    // The CRC polynomial in binary is 0x04C11DB7
    parameter POLY = 32'h04C11DB7; 
    integer i, j;

    always @(*) begin
        crc_out = 32'hFFFFFFFF; // Initial value
        for (i = 0; i < 32; i = i + 1) begin
            crc_out[31] = crc_out[31] ^ data_in[31 - i];
            for (j = 0; j < 32; j = j + 1) begin
                if (crc_out[31] == 1'b1) begin
                    crc_out = (crc_out << 1) ^ POLY;
                end else begin
                    crc_out = crc_out << 1;
                end
            end
        end
        crc_out = ~crc_out; // Final XOR with 0xFFFFFFFF
    end
endmodule