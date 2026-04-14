module top_module(
  input [2:0] sel,
  input [3:0] data0,
  input [3:0] data1,
  input [3:0] data2,
  input [3:0] data3,
  input [3:0] data4,
  input [3:0] data5,
  output reg [3:0] out
);wire [5:0] sel_decoded;
  assign sel_decoded = {~sel[2] & ~sel[1] & ~sel[0], ~sel[2] & ~sel[1] & sel[0], ~sel[2] & sel[1] & ~sel[0], ~sel[2] & sel[1] & sel[0], sel[2] & ~sel[1] & ~sel[0], sel[2] & ~sel[1] & sel[0]};

  wire [3:0] mux0_out, mux1_out, mux2_out;
  assign mux0_out = sel_decoded[0] ? data0 : data1;
  assign mux1_out = sel_decoded[1] ? data2 : data3;
  assign mux2_out = sel_decoded[2] ? data4 : data5;

  wire [3:0] mux3_out;
  assign mux3_out = sel_decoded[3] ? mux0_out : mux1_out;

  wire [3:0] mux4_out;
  assign mux4_out = sel_decoded[4] ? mux2_out : 4'b0;

  assign out = sel_decoded[5] ? mux3_out : mux4_out;

endmodule