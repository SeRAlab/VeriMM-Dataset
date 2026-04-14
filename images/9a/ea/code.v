module top_module(
  input clk,
  input we,
  input [9:0] addr,
  input [7:0] data,
  output reg [7:0] q
);reg [7:0] mem [0:1023]; // declare the RAM variable

  always @(posedge clk) begin
    if (we) // write
      mem[addr] <= data;
  end

  always @(addr or we) begin
    if (!we) // read
      q <= mem[addr];
  end

endmodule