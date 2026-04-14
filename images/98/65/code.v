module top_module(
  input clk,                 // added clock input
  input [7:0] data_in,
  output reg [7:0] data_out, // changed to reg type
  output reg error           // changed to reg type
);parameter n = 8; // number of bits in the data word
parameter p = 3; // number of parity bits

reg [n-1:0] memory [2**p-1:0]; // memory block to store encoded data
reg [n+p-1:0] encoded_data; // encoded data with parity bits
integer i;

// Encoding data using Hamming code
always @(*) begin
  encoded_data[2] = data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[6];
  encoded_data[4] = data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[5] ^ data_in[6];
  encoded_data[7] = data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[7];
  encoded_data[1] = data_in[1];
  encoded_data[3] = data_in[3];
  encoded_data[5] = data_in[4];
  encoded_data[6] = data_in[5];
  encoded_data[8] = data_in[6];
  encoded_data[0] = data_in[7]; // fix: encoded_data[0] assignment
end

// Storing encoded data in memory block
always @(posedge clk) begin
  for (i = 0; i < n+p; i = i+1) begin
    memory[i] <= encoded_data[i];
  end
end

// Reading data from memory block and detecting/correcting errors
reg [p-1:0] syndrome;
reg [n+p-1:0] corrected_data;
integer j;

always @(posedge clk) begin
  syndrome = 0;
  for (j = 0; j < n+p; j = j+1) begin
    if (memory[j]) begin
      syndrome = syndrome ^ j;
    end
  end

  corrected_data = memory[syndrome];
  if (syndrome != 0) begin
    corrected_data[syndrome] = ~corrected_data[syndrome];
  end

  for (j = 0; j < n; j = j+1) begin
    data_out[j] <= corrected_data[j+1]; // Adjusted indexing for data_out
  end

  error <= (syndrome != 0);
end

endmodule