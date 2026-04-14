module shift_register (
  input clk,
  input d,
  output reg [3:0] q);always @(posedge clk) begin
  q <= {q[2:0], d};
end

endmodule