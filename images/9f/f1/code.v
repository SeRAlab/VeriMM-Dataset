module top_module(
  input [k-1:0] in,
  input rst,
  input en,
  input clk,
  output reg [n-1:0] out // Change from wire to reg since we'll be assigning values in always block
);parameter k = 4; // length of input data word
parameter n = 7; // length of output code word

reg [k-1:0] data_in;
reg [n-1:0] data_out;
reg [n-k-1:0] parity;
reg [n-1:0] syndrome;
reg [k-1:0] corrected_data;

// Encoder
always @ (posedge clk) begin
  if (rst) begin
    data_out <= 0;
    parity <= 0;
  end else if (en) begin
    // Calculate parity bits
    parity[0] = data_in[0] ^ data_in[1] ^ data_in[3];
    parity[1] = data_in[0] ^ data_in[2] ^ data_in[3];
    parity[2] = data_in[1] ^ data_in[2] ^ data_in[3];
    
    // Concatenate data and parity bits
    data_out = {data_in, parity};
  end
end

// Decoder
always @ (posedge clk) begin
  if (rst) begin
    syndrome <= 0;
    corrected_data <= 0;
    out <= 0; // Initialize out on reset
  end else if (en) begin
    // Calculate syndrome using data_out instead of data_in
    syndrome[0] = data_out[0] ^ data_out[2] ^ data_out[4] ^ data_out[6];
    syndrome[1] = data_out[1] ^ data_out[2] ^ data_out[5] ^ data_out[6];
    syndrome[2] = data_out[3] ^ data_out[4] ^ data_out[5] ^ data_out[6];
    
    // Correct errors
    if (syndrome != 0) begin
      corrected_data = data_out[k-1:0]; // Get data part of output
      corrected_data[syndrome-1] = ~corrected_data[syndrome-1];
    end else begin
      corrected_data = data_out[k-1:0];
    end
    
    // Output corrected data
    out <= corrected_data; // Assign out using non-blocking assignment
  end
end

// Assign input signals
assign data_in = in;

endmodule