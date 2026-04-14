module crc8_generator(
    input [7:0] data,
    output [7:0] crc
);
    wire [15:0] shifted_data;
    wire [15:0] crc_value;

    assign shifted_data = {data, 8'b0}; // Shift data left by 8 bits
    assign crc_value = shifted_data ^ (shifted_data >> 8) ^ (shifted_data >> 7) ^ (shifted_data >> 6) ^
                       (shifted_data >> 5) ^ (shifted_data >> 4) ^ (shifted_data >> 3) ^ (shifted_data >> 2);

    assign crc = crc_value[7:0]; // Take the lower 8 bits as CRC
endmodule