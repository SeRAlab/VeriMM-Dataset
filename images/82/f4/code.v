module top_module(input clk, input reset,
    input  io_out_ready,
    output io_out_valid,
    output[31:0] io_out_bits,
    output[4:0] io_out_tag,
    output io_in_0_ready,
    input  io_in_0_valid,
    input [31:0] io_in_0_bits,
    input [4:0] io_in_0_tag,
    output io_in_1_ready,
    input  io_in_1_valid,
    input [31:0] io_in_1_bits,
    input [4:0] io_in_1_tag,
    output io_chosen);wire T0;
  wire[4:0] T1;
  wire[6:0] T2;
  wire[6:0] T3;
  wire[6:0] T4;
  wire T5;
  wire[1:0] T6;
  wire[2:0] T7;
  wire choose;
  wire T8;
  wire T9;
  wire T10;
  reg[0:0] last_grant;
  wire T11;
  wire T12;
  wire[6:0] tvec_1;
  wire[6:0] T13;
  wire[6:0] T14;
  wire[6:0] T15;
  wire T16;
  wire[6:0] tvec_0;
  wire[6:0] T17;

  assign io_out_valid = T0;
  assign T0 = io_in_0_valid || io_in_1_valid;
  assign io_out_tag = T1;
  assign T1 = T2[3'h4:1'h0];
  assign T2 = T14 | T3;
  assign T3 = tvec_1 & T4;
  assign T4 = {3'h7{T5}};
  assign T5 = T6[1'h1];
  assign T6 = T7[1'h1:1'h0];
  assign T7 = 2'h1 << choose;
  assign choose = T9 ? 1'h1 : T8;
  assign T8 = io_in_0_valid ? 1'h0 : 1'h1;
  assign T9 = io_in_1_valid && T10;
  assign T10 = 1'h1 > last_grant;
  assign T11 = io_out_valid && io_out_ready;
  assign T12 = T11 ? choose : last_grant;
  assign tvec_1 = T13;
  assign T13 = {2'h0, io_in_1_tag};
  assign T14 = tvec_0 & T15;
  assign T15 = {3'h7{T16}};
  assign T16 = T6[1'h0];
  assign tvec_0 = T17;
  assign T17 = {2'h0, io_in_0_tag};

  always @(posedge clk) begin
    if(reset) begin
      last_grant <= 1'h0;
    end else if(T11) begin
      last_grant <= T12;
    end
  end
endmodule