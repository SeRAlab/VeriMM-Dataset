module top_module(g8,
    rgb888);input [7:0]g8;
  output [23:0]rgb888;

  wire [7:0]g8;

  assign rgb888[23:16] = g8;
  assign rgb888[15:8] = g8;
  assign rgb888[7:0] = g8;
endmodule