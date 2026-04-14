module top_module(
  input clk,
  input wr_en1,
  input wr_en2,
  input [ADDR_WIDTH-1:0] addr1,
  input [ADDR_WIDTH-1:0] addr2,
  input [width-1:0] data_in1,
  input [width-1:0] data_in2,
  output [width-1:0] data_out1,
  output [width-1:0] data_out2
);parameter width = 8; // width of the RAM block
parameter depth = 16; // depth of the RAM block
localparam ADDR_WIDTH = $clog2(depth); // Calculate address width based on depth

reg [width-1:0] mem [0:depth-1];

always @(posedge clk) begin
  if (wr_en1) begin
    mem[addr1] <= data_in1;
  end
  if (wr_en2) begin
    mem[addr2] <= data_in2;
  end
end

assign data_out1 = mem[addr1];
assign data_out2 = mem[addr2];

endmodule