module crc_generator (
    input [3:0] data,
    output [3:0] crc
);
    assign crc[3] = data[3] ^ data[2]; // x^3 coefficient
    assign crc[2] = data[2] ^ data[1]; // x^2 coefficient
    assign crc[1] = data[1] ^ data[0]; // x^1 coefficient
    assign crc[0] = data[0];            // x^0 coefficient
endmodule