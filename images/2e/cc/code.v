module crc32_generator(
    input [31:0] data,
    output reg [31:0] crc
);
    integer i, j;
    reg [31:0] polynomial = 32'h04C11DB7; // CRC32 polynomial
    reg [31:0] temp;

    always @(*) begin
        crc = 32'hFFFFFFFF; // Initial value
        temp = data;

        for (i = 0; i < 32; i = i + 1) begin
            if ((crc[31] ^ temp[31]) != 0) begin
                crc = (crc << 1) ^ polynomial;
            end else begin
                crc = crc << 1;
            end
            temp = temp << 1;
        end

        crc = ~crc; // Final XOR with 0xFFFFFFFF
    end
endmodule