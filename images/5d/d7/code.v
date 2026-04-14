module top_module(
  input clk_in,
  input rst,
  output reg clk_out_200,
  output reg clk_out_400
);reg [31:0] counter_200 = 0;
  reg [31:0] counter_400 = 0;

  always @(posedge clk_in or negedge rst) begin
    if (~rst) begin
      counter_200 <= 0;
      counter_400 <= 0;
      clk_out_200 <= 0;
      clk_out_400 <= 0;
    end else begin
      counter_200 <= counter_200 + 1;
      counter_400 <= counter_400 + 1;
      if (counter_200 == 124) begin
        counter_200 <= 0;
        clk_out_200 <= ~clk_out_200;
      end
      if (counter_400 == 62) begin
        counter_400 <= 0;
        clk_out_400 <= ~clk_out_400;
      end
    end
  end

endmodule