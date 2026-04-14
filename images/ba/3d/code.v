module top_module(in, out);parameter WIDTH = 8;
  
  input [WIDTH-1:0] in;  
  output [WIDTH-1:0] out;  
  
  wor rez;  
  genvar g;
  assign rez = in[0];
  generate for(g = 1; g < WIDTH; g = g+1) begin : adsf  
    assign rez = in[g];
  end  endgenerate
  
  generate for(g = 0; g < WIDTH; g = g+1) begin : adsfjo
    assign out[g] = ~rez;
  end  endgenerate
endmodule