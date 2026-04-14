module top_module(input wire clk, input wire en, input wire I, output reg O);reg[7:0] counter; 
  reg II; 
  always@(posedge clk) begin 
  II <= I; 
  if (counter[7] && II != O) begin 
  O <= II; 
  counter <= 28; 
  end 
  else if (en) 
  counter <= counter + 1; 
  end 
 endmodule