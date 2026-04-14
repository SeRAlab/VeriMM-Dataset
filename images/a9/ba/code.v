module top_module(
  input [n-1:0] data,
  output [m-1:0] comp
);parameter n = 8; // number of data signals
parameter m = 4; // number of compressed data signals

// Compression algorithm
assign comp[0] = ~(data[0] & data[1] & data[2] & data[3]);
assign comp[1] = ~(data[4] & data[5] & data[6] & data[7]);
assign comp[2] = ~(data[0] & data[2] & data[4] & data[6]);
assign comp[3] = ~(data[1] & data[3] & data[5] & data[7]);

// Decompression algorithm
assign {data[0], data[1], data[2], data[3]} = ~comp[0];
assign {data[4], data[5], data[6], data[7]} = ~comp[1];
assign {data[0], data[2], data[4], data[6]} = ~comp[2];
assign {data[1], data[3], data[5], data[7]} = ~comp[3];

endmodule