module top_module(Clk, rdEn, wrEn, addr, wrData, Data);parameter WIDTH = 8; 
  parameter DEPTH = 256; 
  input Clk; 
  input rdEn, wrEn; 
  input [WIDTH-1:0] wrData; 
  input [7:0] addr; 
  output [WIDTH-1:0] Data; 
  reg [WIDTH-1:0] data_out; 
  reg [WIDTH-1 : 0] memory[DEPTH-1 : 0]; 
  always @ (posedge Clk) 
  begin : DATA_MEM 
  data_out <= 100'bx; 
  if (wrEn) 
  begin 
  memory[addr] <= wrData; 
  end 
  if (rdEn) 
  begin 
  data_out <= memory[addr]; 
  end 
  end 
  assign Data = data_out; 
 endmodule