module crc_generator (
    input [7:0] data_in,
    output [7:0] crc_out
);
    assign crc_out = data_in ^ (data_in >> 1) ^ (data_in >> 4); // Simple CRC logic
endmodule