module top_module(
  RGB565,
  RGB332
);input  [15:0] RGB565;
output wire [7:0] RGB332;

assign RGB332 = {RGB565[15:13], RGB565[10:8], RGB565[4:3]};

endmodule