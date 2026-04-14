module top_module(
  input [3:0] data_in,
  input [1:0] select,
  output reg data_out
);wire and1, and2, and3, and4;
  wire or1, or2;

  assign and1 = (select == 2'b00) ? data_in[0] : 1'b0;
  assign and2 = (select == 2'b01) ? data_in[1] : 1'b0;
  assign and3 = (select == 2'b10) ? data_in[2] : 1'b0;
  assign and4 = (select == 2'b11) ? data_in[3] : 1'b0;

  assign or1 = and1 | and2;
  assign or2 = and3 | and4;

  assign data_out = (select == 2'b00 || select == 2'b01) ? or1 : or2;

endmodule