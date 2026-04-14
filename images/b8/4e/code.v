module top_module(
  input [n-1:0] in,
  output [m-1:0] out
);parameter n = 16; // number of input signals
parameter m = 8; // number of output signals
parameter k = 4; // number of bits used to store the compressed data

reg [k-1:0] compressed_data [0:m-1]; // array of registers to store the compressed data

// Compression function
function [m-1:0] compress;
  input [n-1:0] data;
  integer i;
  reg [k-1:0] temp;
  begin
    for (i = 0; i < m; i = i + 1) begin
      temp = data[i*k +: k];
      compressed_data[i] = temp; 
    end
    compress = {compressed_data[0], compressed_data[1], compressed_data[2], compressed_data[3], compressed_data[4], compressed_data[5], compressed_data[6], compressed_data[7]};
  end
endfunction

// Decompression function
function [n-1:0] decompress;
  input [m-1:0] data;
  integer i;
  reg [k-1:0] temp;
  begin
    for (i = 0; i < m; i = i + 1) begin
      temp = data[i]; // Change here from compressed_data[i] to data[i]
      decompress[i*k +: k] = temp; // Corrected: Indexing is by range, not array access
    end
  end
endfunction

// Assign compressed data to output
assign out = compress(in);

// Decompression test (optional)
reg [n-1:0] decompressed_data;
always @(out) begin
  decompressed_data = decompress(out);
end

endmodule