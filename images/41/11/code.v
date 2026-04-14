module top_module(
  input clk,
  output reg [15:0] LFSR
);always @(posedge clk)
begin
  LFSR[0] <= ~(LFSR[1] ^ LFSR[2] ^ LFSR[4] ^ LFSR[15]);
  LFSR[15:1] <= LFSR[14:0];
end
endmodule