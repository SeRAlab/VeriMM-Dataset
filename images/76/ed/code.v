module top_module(sum,co,a,b,ci);output reg sum;
  output reg co;
  input wire a;
  input wire b;
  input wire ci;

always@(a or b or ci)
  begin
    sum = a ^ b ^ ci;
    co  = a*b || a*ci || b*ci;
  end
endmodule