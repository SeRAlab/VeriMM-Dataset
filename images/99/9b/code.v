module top_module(
  input clk,
  input we1, we2,
  input [addr_width-1:0] addr1, addr2,
  input [width-1:0] data_in1, data_in2,
  output reg [width-1:0] data_out1, data_out2
);parameter depth = 1024;
parameter width = 16;

// Calculate address width using a localparam instead of log2 function
localparam addr_width = $clog2(depth);
reg [width-1:0] mem [0:depth-1];

always @(posedge clk) begin
  if (we1) mem[addr1] <= data_in1;
  if (we2) mem[addr2] <= data_in2;
  data_out1 <= mem[addr1];
  data_out2 <= mem[addr2];
end

endmodule