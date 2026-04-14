module top_module(clk, reset, value_out, value_in);input clk;
  input reset;
  output reg [7:0] value_out;
  input [7:0] value_in;

  always @(posedge clk) begin
    if (reset) begin
      value_out <= value_in;
    end else begin
      value_out <= value_out + 1;
    end
  end

endmodule