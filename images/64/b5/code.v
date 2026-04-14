module top_module(
  input [3:0] binary_in,
  input clk,
  input reset,
  output reg [2:0] ones_count
);reg [3:0] stage1_out;
  reg [2:0] stage2_out;
  reg [1:0] stage3_out;
  reg [0:0] stage4_out;

  always @(posedge clk) begin
    if (reset) begin
      stage1_out <= 4'b0;
      stage2_out <= 3'b0;
      stage3_out <= 2'b0;
      stage4_out <= 1'b0;
      ones_count <= 3'b0;
    end else begin
      stage1_out <= binary_in;
      stage2_out <= stage1_out[3] + stage1_out[2:1] + stage1_out[0];
      stage3_out <= stage2_out[2] + stage2_out[1];
      stage4_out <= stage3_out[1];
      ones_count <= stage4_out;
    end
  end

endmodule