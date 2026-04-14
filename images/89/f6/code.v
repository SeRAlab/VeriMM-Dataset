module top_module(
  input clk,
  input reset,
  input d_in,
  output reg d_out_1,
  output reg d_out_2
);reg d_ff_1, d_ff_2;
wire toggle;

assign toggle = (d_out_1 ^ d_in);

always @(posedge clk, negedge reset) begin
  if (!reset) begin
    d_ff_1 <= 1'b0;
    d_ff_2 <= 1'b0;
  end else begin
    d_ff_1 <= d_in;
    d_ff_2 <= toggle;
  end
end

assign d_out_1 = d_ff_1;
assign d_out_2 = d_ff_2;

endmodule