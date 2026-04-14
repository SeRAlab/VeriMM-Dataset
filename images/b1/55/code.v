module top_module(
  input clk,
  input reset,
  input [7:0] in1,
  input [7:0] in2,
  output [15:0] out,
  output [7:0] out_lo
);reg [15:0] result;
  reg [7:0] lo_result;
  reg [7:0] multiplier;
  reg [7:0] multiplicand;
  reg [3:0] i;

  always @(posedge clk) begin
    if (reset) begin
      result <= 16'd0;
      lo_result <= 8'd0;
      multiplier <= 8'd0;
      multiplicand <= 8'd0;
      i <= 4'd0;
    end else begin
      result <= result + (multiplier * multiplicand);
      lo_result <= result[7:0];
      if (i == 4'd7) begin
        i <= 4'd0;
        multiplier <= multiplier >> 1;
        multiplicand <= multiplicand << 1;
      end else begin
        i <= i + 1;
        multiplier <= {1'b0, multiplier[7:1]};
        multiplicand <= {multiplicand[6:0], 1'b0};
      end
    end
  end

  assign out = result;
  assign out_lo = lo_result;

endmodule