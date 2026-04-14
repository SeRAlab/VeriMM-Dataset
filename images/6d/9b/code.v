module top_module(out, in);output out;
  input in;
  wire out, in;

  assign out = ~in;

  specify
    (in => out) = (1.134, 0);
  endspecify
endmodule