module top_module(clk, wea, web, addra, addrb, dia, dib, doa, dob);parameter ADDR_WIDTH = 0; 
  parameter DATA_WIDTH = 0; 
  parameter DEPTH = 1 << ADDR_WIDTH; 
  input clk; 
  input wea, web; 
  input [ADDR_WIDTH-1:0] addra, addrb; 
  input [DATA_WIDTH-1:0] dia, dib; 
  output reg [DATA_WIDTH-1:0] doa, dob; 
  reg [DATA_WIDTH-1:0] RAM [DEPTH-1:0]; 
  always @(negedge clk) begin 
  if (wea) 
  RAM[addra] <= dia; 
  doa <= RAM[addra]; 
  end 
  always @(negedge clk) begin 
  if (web) 
  RAM[addrb] <= dib; 
  dob <= RAM[addrb]; 
  end 
 endmodule