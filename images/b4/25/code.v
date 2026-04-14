module top_module(
  input enable,
  input [10:0] x, y,
  input [10:0] center_x, center_y,
  input [10:0] width, height,
  output reg show
);always @ (*)
  if (!enable)
    show = ((x > center_x - width >> 1) && (x < center_x + width >> 1) && (y > center_y - height >> 1) && (y < center_y + height >> 1));
  else
    show = 0;
endmodule