module top_module(
  input [n-1:0] in,
  output reg [m-1:0] out,
  output reg Match,
  output reg [k-1:0] Address,
  output [m-1:0] Data
);parameter n = 8; // number of bits in search key
parameter m = 16; // number of bits in each data word
parameter k = 4; // number of bits in address
parameter N = 256; // number of data words in the CAM

reg [m-1:0] data_array [0:N-1]; // array of N data words

integer i;
reg [m-1:0] match_data;
reg [k-1:0] match_addr;

always @(*) begin
  Match = 0; // Reset Match signal
  match_data = 0; // Reset match_data
  match_addr = 0; // Reset match_addr
  for (i = 0; i < N; i = i + 1) begin
    if (data_array[i] == in) begin
      Match = 1;
      match_data = data_array[i];
      match_addr = i;
    end
  end
end

assign out = match_data;
assign Address = match_addr;
assign Data = match_data;

endmodule