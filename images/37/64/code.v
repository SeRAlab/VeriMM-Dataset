module crc_generator (
    input [15:0] data_in,
    output reg [15:0] crc_out
);
    // Example polynomial: x^16 + x^12 + x^5 + 1 (0xA001)
    parameter [15:0] POLY = 16'hA001;
    
    integer i, j;
    reg [15:0] crc;

    always @(*) begin
        crc = 16'hFFFF; // Initial value
        for (i = 0; i < 16; i = i + 1) begin
            crc = crc ^ data_in[i]; // XOR input bit
            for (j = 0; j < 8; j = j + 1) begin
                if (crc[0] == 1) begin
                    crc = (crc >> 1) ^ POLY; // Shift and XOR with polynomial
                end else begin
                    crc = crc >> 1; // Just shift
                end
            end
        end
        crc_out = crc;
    end
endmodule