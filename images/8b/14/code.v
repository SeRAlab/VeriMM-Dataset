module top_module(
  input [k-1:0] in,
  output [n-1:0] out
);parameter k = 4; // number of input bits
parameter r = 3; // number of redundant bits

parameter n = k + r; // number of output bits

// Encoder
wire [r-1:0] parity;
wire [n-1:0] encoded;

assign parity[0] = in[0] ^ in[1] ^ in[3];
assign parity[1] = in[0] ^ in[2] ^ in[3];
assign parity[2] = in[1] ^ in[2] ^ in[3];

assign encoded[0] = parity[0];
assign encoded[1] = parity[1];
assign encoded[2] = in[0];
assign encoded[3] = parity[2];
assign encoded[4] = in[1];
assign encoded[5] = in[2];
assign encoded[6] = in[3];

assign out = encoded;

// Decoder
wire [r-1:0] syndrome;
wire [n-1:0] decoded;

assign syndrome[0] = in[0] ^ in[2] ^ in[4] ^ in[6];
assign syndrome[1] = in[1] ^ in[2] ^ in[5] ^ in[6];
assign syndrome[2] = in[3] ^ in[4] ^ in[5] ^ in[6];

assign decoded[0] = in[2];
assign decoded[1] = in[4];
assign decoded[2] = in[5];
assign decoded[3] = in[6];

assign decoded[4] = syndrome[0] ^ in[0];
assign decoded[5] = syndrome[1] ^ in[1];
assign decoded[6] = syndrome[2] ^ in[3];

assign out = decoded;

endmodule