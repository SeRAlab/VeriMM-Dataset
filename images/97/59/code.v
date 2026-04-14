module top_module(input clk,input rst_n,input [(32*5-1):0] values,output reg [31:0] rows);reg [4:0] n; 
  always @(posedge clk) begin 
  if (!rst_n) 
  n = 0; 
 `define pulse(i) rows[i] = n < values[4+(5*i):(5*i)] 
  `pulse(0); 
  `pulse(1); 
  `pulse(2); 
  `pulse(3); 
  `pulse(4); 
  `pulse(5); 
  `pulse(6); 
  `pulse(7); 
  `pulse(8); 
  `pulse(9); 
  `pulse(10); 
  `pulse(11); 
  `pulse(12); 
  `pulse(13); 
  `pulse(14); 
  `pulse(15); 
  `pulse(16); 
  `pulse(17); 
  `pulse(18); 
  `pulse(19); 
  `pulse(20); 
  `pulse(21); 
  `pulse(22); 
  `pulse(23); 
  `pulse(24); 
  `pulse(25); 
  `pulse(26); 
  `pulse(27); 
  `pulse(28); 
  `pulse(29); 
  `pulse(30); 
  `pulse(31); 
  n = n+1; 
  end 
 endmodule