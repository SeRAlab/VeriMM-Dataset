module top_module(
  input wire a,
  input wire b,
  output reg y
);always @ (a, b) begin
    if (a && b)
      y <= 1'b1;
    else
      y <= 1'b0;
  end
  
endmodule