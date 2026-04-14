module top_module(clk,reset,n,result,ready);parameter inBits = 8; 
 parameter outBits = 16; 
 input clk; 
 input reset; 
 input [inBits-1:0] n; 
 output reg [outBits-1:0] result; 
 output reg ready; 
 reg [outBits-1:0] last; 
 reg [inBits-1:0] no; 
 reg [inBits-1:0] count; 
 always @(posedge clk) begin 
  if (reset) begin 
  result <= 16'b0; 
  last <= 16'b0; 
  no <= n; 
  count <= 16'b0; 
  end else begin 
  if (result == 0 && !ready) begin 
  result <= 1; 
  end else if (ready) begin 
  result <= result; 
  end else begin 
  result <= result + last; 
  end 
  last <= result; 
  count <= count + 1; 
  end 
  ready <= count >= no; 
  $display("reset %b, count %d, result %d, ready %b, no %d, last %d",reset, count, result, ready, no, last); 
 end 
 endmodule