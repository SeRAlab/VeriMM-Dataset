module top_module(
  input [1:0] sel,
  input [7:0] a,
  input [7:0] b,
  input [7:0] c,
  input [7:0] d,
  output [7:0] out
);wire [7:0] mux_out;

  assign mux_out = (sel == 2'b00) ? a :
                   (sel == 2'b01) ? b :
                   (sel == 2'b10) ? c :
                                    d;

  assign out = mux_out;

endmodule