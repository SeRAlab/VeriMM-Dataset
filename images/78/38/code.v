module top_module(
  input [1:0] sel,
  input a,
  input b,
  output reg out
);always @(*) begin
    if(sel == 0)
      out = a;
    else if(sel == 1)
      out = b;
    else if(sel == 2)
      out = a & b;
  end
  
endmodule