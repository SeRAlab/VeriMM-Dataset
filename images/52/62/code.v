module top_module(
  input [3:0] data_in,
  input [1:0] sel,
  output out0,
  output out1,
  output out2,
  output out3
);assign out0 = (sel == 2'b00) ? data_in : 0;
  assign out1 = (sel == 2'b01) ? data_in : 0;
  assign out2 = (sel == 2'b10) ? data_in : 0;
  assign out3 = (sel == 2'b11) ? data_in : 0;

endmodule