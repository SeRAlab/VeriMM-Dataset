module top_module(clk,
   we,
   addr,
   wdata,
   rdata);parameter DEPTH = 256;
  parameter WIDTH = 64;

  input clk;
  input we;
  input [7:0] addr;
  input [WIDTH-1:0] wdata;
  output reg [WIDTH-1:0] rdata;

  reg [WIDTH-1:0] mem [0:DEPTH-1];

  always @(posedge clk) begin
    if (we) begin
      mem[addr] <= wdata;
    end
    rdata <= mem[addr];
  end

endmodule