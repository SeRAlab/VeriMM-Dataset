module top_module(
  input data_in,
  input key_in,
  input mode,
  output data_out
);assign data_out = (mode == 1'b0) ? (data_in ^ key_in) : (data_in ^ ~key_in);

endmodule