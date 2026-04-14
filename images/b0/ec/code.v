module top_module(
  input [k-1:0] data_in,
  output [n-1:0] codeword_out,
  input [n-1:0] codeword_in,
  output [k-1:0] data_out,
  output error_detected
);parameter k = 4; // number of data bits
parameter r = 3; // number of parity bits

localparam n = k + r; // total number of bits

// Calculate the positions of the parity bits in the codeword
localparam [r-1:0] parity_positions = {2'b01, 2'b10, 2'b11}; // Corrected to use 2 bits for positions

// Calculate the parity bits
wire [r-1:0] parity_bits;
assign parity_bits[0] = data_in[0] ^ data_in[1] ^ data_in[3];
assign parity_bits[1] = data_in[0] ^ data_in[2] ^ data_in[3];
assign parity_bits[2] = data_in[1] ^ data_in[2] ^ data_in[3];

// Combine the data bits and parity bits to form the codeword
assign codeword_out = {parity_bits, data_in};

// Calculate the syndrome of the received codeword
wire [r-1:0] syndrome;
assign syndrome[0] = codeword_in[parity_positions[0]] ^ codeword_in[parity_positions[1]] ^ codeword_in[parity_positions[2]];
assign syndrome[1] = codeword_in[parity_positions[0]] ^ codeword_in[parity_positions[1]] ^ codeword_in[0];
assign syndrome[2] = codeword_in[parity_positions[0]] ^ codeword_in[parity_positions[2]] ^ codeword_in[0];

// Determine the bit position of any error based on the syndrome
wire [n-1:0] error_position;
assign error_position = {syndrome[2], syndrome[1], syndrome[0], 1'b0} ^ codeword_in;

// Correct the error by flipping the incorrect bit
assign data_out = codeword_in[n-1:k]; // Extract the data bits
assign error_detected = (error_position != 0);

endmodule