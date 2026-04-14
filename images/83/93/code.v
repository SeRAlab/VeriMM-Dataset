module top_module(
  input in,
  input [m-1:0] sel, 
  output [2**m-1:0] out
);parameter m = 3; // number of select bits

assign out[0] = sel == 0 ? in : 0; // Route input to out1 if sel is 0

// Use a loop to route input to the correct output based on sel
genvar i;
generate 
  for (i = 1; i < 2**m; i = i + 1) begin : ROUTE_OUTPUT
    assign out[i] = sel == i ? in : 0;
  end
endgenerate

endmodule