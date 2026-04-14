module top_module(ram_dout,ram_addr,ram_cen,ram_clk,ram_din,ram_wen);parameter ADDR_MSB = 6; 
 parameter MEM_SIZE = 256; 
 output [15:0] ram_dout; 
 input [ADDR_MSB:0] ram_addr; 
 input ram_cen; 
 input ram_clk; 
 input [15:0] ram_din; 
 input [1:0] ram_wen; 
 reg [15:0] mem [0:(MEM_SIZE/2)-1]; 
 reg [ADDR_MSB:0] ram_addr_reg; 
 wire [15:0] mem_val = mem[ram_addr]; 
 always @(posedge ram_clk) 
  if (~ram_cen & ram_addr<(MEM_SIZE/2)) 
  begin 
  if (ram_wen==2'b00) mem[ram_addr] <= ram_din; 
  else if (ram_wen==2'b01) mem[ram_addr] <= {ram_din[15:8], mem_val[7:0]}; 
  else if (ram_wen==2'b10) mem[ram_addr] <= {mem_val[15:8], ram_din[7:0]}; 
  ram_addr_reg <= ram_addr; 
  end 
 assign ram_dout = mem[ram_addr_reg]; 
 endmodule