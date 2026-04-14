module top_module(out, in);output out;
  input in;

  buf(out, in);

  specify
    (in => out) = 1;
  endspecify
endmodule