module top_module( in, mux_out, out, sel
  );input in;
  output mux_out;
  output out;
  input [4:0] sel;

  assign mux_out = in;
  assign out = in;
endmodule