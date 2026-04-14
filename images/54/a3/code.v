module top_module(clkin, reset, clkoutp, clkoutn);parameter clkdiv = 2; 
  input clkin; 
  input reset; 
  output clkoutp, clkoutn; 
  wire clkin; 
  reg clkoutp, clkoutn; 
  reg clkbase, clkgen; 
  reg [6:0] clkcnt; 
  always @(posedge clkin or negedge reset) 
  if (~reset) 
  begin 
  clkcnt <= 0; 
  clkbase <= 0; 
  clkoutp <= 0; 
  clkoutn <= 0; 
  end 
  else 
  begin 
  clkoutp <= 0; 
  clkoutn <= 0; 
  if (clkcnt == clkdiv) 
  begin 
  clkcnt <= 0; 
  clkbase <= ~clkbase; 
  if (clkbase) clkoutn <= 1; 
  else clkoutp <= 1; 
  end 
  else clkcnt <= clkcnt + 7'd1; 
  end 
  always @(negedge clkin) clkgen <= clkbase; 
 endmodule