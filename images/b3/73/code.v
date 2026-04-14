module top_module(
  input clk,
  input write_en1,
  input write_en2,
  input [ADDR_WIDTH-1:0] addr1,
  input [ADDR_WIDTH-1:0] addr2,
  input [m-1:0] data_in1,
  input [m-1:0] data_in2,
  output reg [m-1:0] data_out1,
  output reg [m-1:0] data_out2
);parameter n = 16; // number of words
parameter m = 8; // number of bits per word
localparam ADDR_WIDTH = $clog2(n); // calculate address width using $clog2

reg [m-1:0] ram [0:n-1];

always @(posedge clk) begin
  if (write_en1) ram[addr1] <= data_in1;
  if (write_en2) ram[addr2] <= data_in2;
  data_out1 <= ram[addr1];
  data_out2 <= ram[addr2];
end

endmodule