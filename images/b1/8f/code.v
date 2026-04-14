module top_module(X, A, Y);parameter WIDTH = 1; 
 parameter SHIFT = 0; 
 input X; 
 input [WIDTH-1:0] A; 
 output [WIDTH-1:0] Y; 
 genvar i; 
 generate 
  for (i = 0; i < WIDTH; i = i + 1) begin:V 
  if (i+SHIFT < 0) begin 
  assign Y[i] = 0; 
  end else 
  if (i+SHIFT < WIDTH) begin 
  assign Y[i] = A[i+SHIFT]; 
  end else begin 
  assign Y[i] = X; 
  end 
  end 
 endgenerate 
 endmodule