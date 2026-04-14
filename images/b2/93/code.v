module top_module(
  input  wire        clk,
  input  wire  [3:0] addr,
  input  wire        wrenb,
  input  wire [31:0] wrdata,
  output reg  [31:0] rddata
);reg [31:0] mem [0:15];


always @ (posedge clk)
if (wrenb) mem[addr] <= wrdata;


always @ (posedge clk)
rddata <= mem[addr];

endmodule