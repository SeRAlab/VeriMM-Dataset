module crc_generator (
    input [31:0] data_in,
    output reg [31:0] crc_out
);
    // Example polynomial: x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x + 1
    parameter POLY = 32'h04C11DB7;

    integer i;
    reg [31:0] crc;

    always @(*) begin
        crc = 32'hFFFFFFFF;  // Initialize CRC
        for (i = 0; i < 32; i = i + 1) begin
            crc = crc ^ (data_in[i] ? POLY : 0);
            if (crc[31]) begin
                crc = crc << 1;
                crc = crc ^ POLY;
            end else begin
                crc = crc << 1;
            end
        end
        crc_out = ~crc;  // Final CRC value
    end
endmodule