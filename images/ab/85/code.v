module top_module(
  input clk,
  input rst_n,
  input signed [15:0] x_re,
  input signed [15:0] x_im,
  input signed [15:0] y_re,
  input signed [15:0] y_im,
  output reg signed [31:0] z_re,
  output reg signed [31:0] z_im
);reg signed [31:0] x_re_fp;
  reg signed [31:0] x_im_fp;
  reg signed [31:0] y_re_fp;
  reg signed [31:0] y_im_fp;
  reg signed [31:0] z_re_fp;
  reg signed [31:0] z_im_fp;

  always @ (posedge clk) begin
    if (!rst_n) begin
      x_re_fp <= 0;
      x_im_fp <= 0;
      y_re_fp <= 0;
      y_im_fp <= 0;
      z_re_fp <= 0;
      z_im_fp <= 0;
    end
    else begin
      x_re_fp <= x_re << 16;
      x_im_fp <= x_im << 16;
      y_re_fp <= y_re << 16;
      y_im_fp <= y_im << 16;
      z_re_fp <= (x_re_fp * y_re_fp - x_im_fp * y_im_fp) >> 16;
      z_im_fp <= (x_re_fp * y_im_fp + x_im_fp * y_re_fp) >> 16;
    end
  end

  assign z_re = z_re_fp[31:16];
  assign z_im = z_im_fp[31:16];

endmodule