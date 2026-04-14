module top_module(clk_i,data_o,data_i,address_i,be_i,wren_i);parameter [31:0] SIZE = 18; 
 input clk_i; 
 output [15:0] data_o; 
 input [15:0] data_i; 
 input [(SIZE - 1):0] address_i; 
 input [1:0] be_i; 
 input wren_i; 
 reg [7:0] ram_ub [((2<< (SIZE-1)) - 1):0]; 
 reg [7:0] ram_lb [((2<< (SIZE-1)) - 1):0]; 
 wire [15:0] data_o; 
 always @ (posedge clk_i ) 
 begin 
  if ((be_i[1] == 1'b0) && (wren_i == 1'b0)) 
  begin 
  ram_ub[address_i] <= data_i[15:8]; 
  end 
  if ((be_i[0] == 1'b0) && (wren_i == 1'b0)) 
  begin 
  ram_lb[address_i] <= data_i[7:0]; 
  end 
 end 
 assign data_o = { ram_ub[address_i], ram_lb[address_i] }; 
 endmodule