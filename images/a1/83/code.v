module top_module(C,I,O);input C;
  input[3:0] I;
  output[4:0] O;
  assign O = {C,I[3:0]};
endmodule