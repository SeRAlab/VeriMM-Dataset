module top_module(
  input a,
  input b,
  output reg y
);wire w1, w2, w3, w4;
  
  nand(w1, a, b);
  nand(w2, a, w1);
  nand(w3, b, w1);
  nand(w4, w2, w3);
  
  always @(w4) begin
    y <= ~w4;
  end
  
endmodule