module top_module(
    i_data0,
    i_data1,
    o_data0
);// Port mode declarations:
  input   [31:0] i_data0, i_data1;
  output  [31:0] o_data0;

  //Adder:
  wire [31:0] w1;
  assign w1 = i_data0 + i_data1;
  assign o_data0 = w1;

endmodule