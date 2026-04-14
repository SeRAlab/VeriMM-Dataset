module top_module(
  input reset,
  input clk,
  input enable,
  input [4:0] data_in,
  output reg [4:0] data_out
);always @(posedge clk) begin
    if (reset) begin
      data_out <= 5'b0;
    end else if (enable) begin
      data_out <= data_out + data_in;
    end
  end

endmodule