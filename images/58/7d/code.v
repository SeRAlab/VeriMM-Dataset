module top_module(out, in, enable);parameter WIDTH = 1;

  input  [WIDTH-1:0] in;
  input              enable;
  output [WIDTH-1:0] out;

  reg  [WIDTH-1:0] out;
  
  always @(in or enable)
      out[WIDTH-1:0] = in[WIDTH-1:0];

endmodule