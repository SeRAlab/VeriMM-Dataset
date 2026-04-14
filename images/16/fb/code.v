module crc_generator (
    input [7:0] data_in,
    output reg [7:0] crc_out
);
    // Polynomial: x^8 + x^7 + x^4 + 1 (binary: 11000001)
    parameter POLY = 8'b11000001;

    integer i;
    reg [7:0] crc;

    always @(*) begin
        crc = 8'b0; // Initialize CRC to zero
        for (i = 0; i < 8; i = i + 1) begin
            crc[7] = data_in[i] ^ crc[7]; // XOR with the current data bit
            if (crc[7]) begin
                crc = (crc << 1) ^ POLY; // Shift left and XOR with the polynomial
            end else begin
                crc = crc << 1; // Just shift left
            end
        end
        crc_out = crc; // Output the resulting CRC
    end
endmodule