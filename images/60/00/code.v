module top_module(
  input clk,
  input wren1,
  input wren2,
  input [ADDR_WIDTH-1:0] addr1,
  input [ADDR_WIDTH-1:0] addr2,
  input [width-1:0] din1,
  input [width-1:0] din2,
  output [width-1:0] dout1,
  output [width-1:0] dout2
);parameter depth = 1024; // depth of the RAM block
parameter width = 8;    // width of the RAM block
parameter ADDR_WIDTH = $clog2(depth); // Address width based on depth parameter

// memory array
reg [width-1:0] mem [0:depth-1];

// write operations
always @(posedge clk) begin
  if (wren1) begin
    mem[addr1] <= din1;
  end
  if (wren2 && !wren1) begin
    mem[addr2] <= din2;
  end
end

// read operations
assign dout1 = mem[addr1];
assign dout2 = mem[addr2];

endmodule