module top_module(
    input [31:0] i_data0,
    output [31:0] o_data0
);//Multipliers:
  wire [31:0] w1 = i_data0;
  wire [31:0] w256 = w1 << 8;
  wire [31:0] w64 = w1 << 6;
  wire [31:0] w257 = w1 + w256;
  wire [31:0] w321 = w257 + w64;
  wire [31:0] w5136 = w321 << 4;
  wire [31:0] w5457 = w321 + w5136;

  assign o_data0 = w5457;

endmodule