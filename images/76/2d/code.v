module top_module(
  input [n-1:0] bin,
  output [n-1:0] gray
);parameter n = 4; // number of input bits

assign gray[0] = bin[0];
  
generate
  genvar i;
  for (i = 1; i < n; i = i + 1) begin : gray_loop
    assign gray[i] = bin[i] ^ bin[i-1];
  end
endgenerate

endmodule