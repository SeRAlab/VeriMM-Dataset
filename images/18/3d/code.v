module DWT (
    input [3:0] data_in,
    output [3:0] approx_out,
    output [3:0] detail_out
);
    
    assign approx_out = (data_in[3:2] + data_in[1:0]) >> 1; // Average of pairs
    assign detail_out = data_in[3:2] - data_in[1:0]; // Difference of pairs

endmodule