module top_module(input CLK, input[10:0] AB, input CS, input READ, output[7:0] DO, input[7:0] DI);reg[7:0] mem[0:2047]; 
  reg[7:0] R; 
  assign DO = CS? R: 8'bZ; 
  initial begin 
  mem['h7FC] = 8'h00; 
  mem['h7FD] = 8'h18; 
  end 
  always @(posedge CLK) if (CS) if (READ) R <= mem[AB]; else mem[AB] <= DI; 
 endmodule