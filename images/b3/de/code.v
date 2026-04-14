module top_module(
  input clk,            // Add clk input as it was missing
  input [15:0] data_in,
  input enable,
  output reg [15:0] data_out
);always @(posedge clk) begin
  if (enable) begin
    data_out <= data_in;
  end
end

endmodule