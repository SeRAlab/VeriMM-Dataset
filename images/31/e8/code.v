module crc_generator (
    input [7:0] data_in,
    output reg [7:0] crc_out
);
    reg [7:0] crc;
    integer i;

    always @(*) begin
        crc = 8'b00000000; // Initial CRC value
        for (i = 0; i < 8; i = i + 1) begin
            crc = crc ^ data_in[i] ? (crc << 1) ^ 8'b11000011 : crc << 1;
        end
        crc_out = crc;
    end
endmodule