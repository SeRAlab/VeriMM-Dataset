module top_module(
  input clk,
  input reset,
  input enable,
  input [7:0] data_in,
  output reg [7:0] data_out
);reg [7:0] dff_q;

  always @(negedge clk) begin
    if (reset == 1'b0) begin
      dff_q <= 8'b11111111;
    end else if (enable == 1'b1) begin
      dff_q <= data_in;
    end
  end

  assign data_out = enable ? dff_q : 8'b00000000;

endmodule