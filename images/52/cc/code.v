module top_module(
  input clk, // Added clk input
  input [WIDTH-1:0] data_in1,
  input [WIDTH-1:0] data_in2,
  input [WIDTH-1:0] data_in3,
  input [WIDTH-1:0] data_in4,
  input we1,
  input we2,
  input we3,
  input we4,
  input [addr_width-1:0] addr1, // Changed to addr_width
  input [addr_width-1:0] addr2,
  input [addr_width-1:0] addr3,
  input [addr_width-1:0] addr4,
  output [WIDTH-1:0] data_out1,
  output [WIDTH-1:0] data_out2,
  output [WIDTH-1:0] data_out3,
  output [WIDTH-1:0] data_out4
);parameter N = 4; // number of registers
parameter WIDTH = 8; // width of each register
localparam addr_width = $clog2(N); // Calculate address width using $clog2

reg [WIDTH-1:0] register_file [0:N-1];

always @ (posedge clk) begin
  if (we1) register_file[addr1] <= data_in1;
  if (we2) register_file[addr2] <= data_in2;
  if (we3) register_file[addr3] <= data_in3;
  if (we4) register_file[addr4] <= data_in4;
end

assign data_out1 = register_file[addr1];
assign data_out2 = register_file[addr2];
assign data_out3 = register_file[addr3];
assign data_out4 = register_file[addr4];

endmodule