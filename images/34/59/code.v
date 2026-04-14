module crc32_generator(
    input [31:0] data_in,
    output reg [31:0] crc_out
);

    reg [31:0] polynomial = 32'h04C11DB7; // CRC-32 polynomial
    integer i, j;

    always @(*) begin
        crc_out = 32'hFFFFFFFF; // Initialize CRC to all ones
        for (i = 0; i < 32; i = i + 1) begin
            crc_out = crc_out ^ data_in[i]; // XOR input bit with current CRC
            for (j = 0; j < 8; j = j + 1) begin
                if (crc_out[31] == 1'b1) begin
                    crc_out = (crc_out << 1) ^ polynomial; // Shift and XOR with polynomial
                end else begin
                    crc_out = crc_out << 1; // Just shift
                end
            end
        end
        crc_out = ~crc_out; // Final inverse
    end
endmodule