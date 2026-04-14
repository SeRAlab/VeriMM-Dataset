module top_module(
  input [n-1:0] address,
  input [k-1:0] write_data,
  input write_enable,
  output reg [k-1:0] read_data
);parameter n = 4; // number of address signals
parameter k = 8; // number of bits in each memory location
parameter m = 16; // number of memory locations

reg [k-1:0] memory [0:m-1];

always @(*) begin
  if (write_enable) begin
    memory[{address}] <= write_data;
  end
  read_data <= memory[{address}];
end

endmodule