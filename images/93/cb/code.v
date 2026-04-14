module top_module(clk, rst, inp, out);(* this_is_clock = 1 *)
  input  wire clk;
  (* this_is_reset = 1 *)
  input  wire rst;
  input  wire inp;
  (* an_output_register = 1*)
  output reg  out;

  always @(posedge clk)
    if (rst) out <= 1'd0;
    else     out <= ~inp;

endmodule