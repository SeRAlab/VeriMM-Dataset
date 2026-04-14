module top_module(
  output clock40,
  output clock80,
  output clock160
);reg clock1x = 0;
reg clock1x_180=0;
reg clock2x_180=0;

wire   clock2x      = clock1x ^ clock1x_180;
wire   clock4x      = clock2x ^ clock2x_180;

always      clock1x      = #12.5 ~clock1x;
always @(*) clock1x_180  = #6.25  clock1x;
always @(*) clock2x_180  = #3.125 clock2x;



assign clock40  = clock1x;
assign clock80  = clock2x;
assign clock160 = clock4x;

endmodule