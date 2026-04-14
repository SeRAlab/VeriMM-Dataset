module top_module(
  input clk,
  input reset,
  input [7:0] in,
  output reg [7:0] out
);always @(posedge clk) begin
  if (reset) begin
    out <= 8'b0;
  end else begin
    out <= {in[3:0], in[7:4]};
  end
end

endmodule