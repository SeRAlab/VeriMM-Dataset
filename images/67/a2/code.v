module top_module(
  input clk,
  input wr_en,
  input rd_en,
  input [addr_width-1:0] addr1,
  input [addr_width-1:0] addr2,
  input [w-1:0] data_in,
  output [w-1:0] data1,
  output [w-1:0] data2
);parameter n = 8; // number of registers
parameter w = 8; // width of each register
localparam addr_width = $clog2(n); // Calculate the address width using $clog2

reg [w-1:0] registers [0:n-1];

always @(posedge clk) begin
  if (wr_en) begin
    registers[addr1] <= data_in;
  end
end

assign data1 = rd_en ? registers[addr1] : 0;
assign data2 = rd_en ? registers[addr2] : 0;

endmodule