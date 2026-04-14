module top_module(
  input             clk,
  input             rst,
  input      [15:0] val_a,
  input      [15:0] val_b,
  output reg [31:0] result
);always @(posedge clk) begin
  if(rst)
    result <= 0;
  else
    result <= val_a + val_b;
end

endmodule