module top_module(
  input clk,
  input reset,
  input enable,
  input data_in,
  output reg data_out
);always @(posedge clk or negedge reset) begin
  if (!reset) begin
    data_out <= 0;
  end else if (enable) begin
    data_out <= data_in;
  end
end

endmodule