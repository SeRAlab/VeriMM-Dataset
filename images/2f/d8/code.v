module crc_generator(
    input [15:0] data_in,
    output reg [15:0] crc_out
);
    reg [15:0] crc;
    integer i;

    always @(*) begin
        // Initialize CRC to 0
        crc = 16'h0000;
        // Process each bit of the data
        for (i = 0; i < 16; i = i + 1) begin
            crc = {crc[14:0], data_in[15-i]} ^ (crc[15] ? 16'hA001 : 16'h0000);
        end
        crc_out = crc;
    end
endmodule