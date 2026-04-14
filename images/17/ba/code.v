module ofdm_mapper (
    input [3:0] data_in,
    output [15:0] data_out
);
    assign data_out = {data_in, data_in, data_in, data_in}; // Repeat input 4 times
endmodule