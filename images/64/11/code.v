module top_module(
   input  logic [1:0] i,
   input  logic [1:0] a,
   output logic [1:0] o
   );assign o = i + a;
endmodule