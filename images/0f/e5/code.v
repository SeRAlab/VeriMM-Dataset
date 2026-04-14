module crc_generator (
    input [7:0] data_in,
    output reg [7:0] crc_out
);
    reg [7:0] crc;
    integer i;

    always @(*) begin
        crc = 8'b0; // Initialize CRC
        for (i = 0; i < 8; i = i + 1) begin
            crc[7] = crc[7] ^ data_in[i]; // XOR the input bit
            if (crc[7] == 1'b1) begin
                crc = {crc[6:0], 1'b0} ^ 8'b10011000; // Polynomial x^8 + x^2 + x + 1
            end else begin
                crc = {crc[6:0], 1'b0};
            end
        end
        crc_out = crc; // Assign calculated CRC to output
    end
endmodule