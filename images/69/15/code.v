module top_module(

  input wire  [31:0] a_i,
  output wire [31:0] twos_comp
  );assign twos_comp = ~a_i + 1'b1;

endmodule