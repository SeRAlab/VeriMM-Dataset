module top_module(
  input clk,
  
  input [15:0] a,
  
  input [7:0] d,
  input we,
  input re,
  output reg [7:0] q);reg [7:0] store[0:32767] ;

  always @(posedge clk)
    if (we) begin
      store[a[14:0]] <= d;
    end else if (re)
      q <= store[a[14:0]];
endmodule