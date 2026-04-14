module top_module(
  input [WIDTH-1:0] in,
  output [WIDTH-1:0] out
);parameter WIDTH = 8;

  genvar i;

  generate
    for (i = 0; i < WIDTH; i = i + 1) begin : NOT_GATE
      assign out[i] = ~in[i];
    end
  endgenerate

endmodule