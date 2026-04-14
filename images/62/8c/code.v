module top_module(input clk, input reset,
    input  io_out_ready,
    output io_out_valid,
    output[31:0] io_out_bits,
    output[4:0] io_out_tag,
    output io_in_0_ready,
    input  io_in_0_valid,
    input [31:0] io_in_0_bits,
    input [4:0] io_in_0_tag,
    output io_chosen);wire[4:0] T0;
  wire[6:0] T1;
  wire[6:0] tvec_0;
  wire[6:0] T2;
  wire T3;
  wire T4;
  wire T5;
  wire T6;
  wire T7;
  reg[0:0] last_grant;
  wire T8;
  wire T9;
  wire T10;

  assign io_out_valid = io_in_0_valid;
  assign io_out_tag = T0;
  assign T0 = T1[3'h4:1'h0];
  assign T1 = tvec_0 & 7'h7f;
  assign tvec_0 = T2;
  assign T2 = {2'h0, io_in_0_tag};
  assign io_in_0_ready = T3;
  assign T3 = T4 && io_out_ready;
  assign T4 = T10 || T5;
  assign T5 = ! T6;
  assign T6 = io_in_0_valid && T7;
  assign T7 = 1'h0 > last_grant;
  assign T8 = io_out_valid && io_out_ready;
  assign T9 = T8 ? 1'h0 : last_grant;
  assign T10 = 1'h0 > last_grant;

  always @(posedge clk) begin
    if(reset) begin
      last_grant <= 1'h0;
    end else if(T8) begin
      last_grant <= T9;
    end
  end
endmodule