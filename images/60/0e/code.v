module top_module(clk,
     we,
     addr,
     din,
     dout);parameter WIDTH = 12;
  parameter ADDR_WIDTH = 10;
  parameter PIXELS_PER_BLOCK = 4;
  parameter BLOCKS_PER_ROW = 32;
  parameter ROWS = 32;
  parameter PIXELS = ROWS * BLOCKS_PER_ROW * PIXELS_PER_BLOCK;

  input clk;
  input we;
  input [ADDR_WIDTH-1:0] addr;
  input [WIDTH-1:0] din;
  output [WIDTH-1:0] dout;

  reg [WIDTH-1:0] mem [0:PIXELS-1];

  always @(posedge clk) begin
    if (we) begin
      mem[addr] = din;
    end
  end

  assign dout = mem[addr / PIXELS_PER_BLOCK * BLOCKS_PER_ROW * PIXELS_PER_BLOCK + 
                     (addr % (BLOCKS_PER_ROW * PIXELS_PER_BLOCK)) / PIXELS_PER_BLOCK * 2 + 
                     (addr % PIXELS_PER_BLOCK) + 
                     ((addr / (BLOCKS_PER_ROW * PIXELS_PER_BLOCK * PIXELS_PER_BLOCK)) * 
                      (BLOCKS_PER_ROW * PIXELS_PER_BLOCK * PIXELS_PER_BLOCK))];

endmodule