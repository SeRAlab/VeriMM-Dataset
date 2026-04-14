module top_module(input in, output out);wire a;
  assign a = ~(in & in);
  assign out = ~(a & a);
endmodule