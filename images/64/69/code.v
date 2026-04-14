module top_module(we, dataout, datain, clk);input we; 
  output[21 - 1:0] dataout; 
  wire[21 - 1:0] dataout; 
  input[21 - 1:0] datain; 
  input clk; 
  reg[21 - 1:0] mem1; 
  reg[21 - 1:0] mem2; 
  assign dataout = mem2 ; 
  always @(posedge clk or posedge we) 
  begin 
  if (we == 1'b1) 
  begin 
  mem1 <= datain; 
  mem2 <= mem1; 
  end 
  else 
  begin 
  mem1 <= mem1; 
  mem2 <= mem2; 
  end 
  end 
  endmodule