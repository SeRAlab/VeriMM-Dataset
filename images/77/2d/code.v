module top_module(
 input [31:0] addr,
 output reg [31:0] out
);always @(addr)
 begin
  out <= addr << 2;
 end
endmodule