module top_module(input wire pclk,input wire copy_in_progress,input wire cpu_clk,input wire cpu_rd,input wire cpu_wr,input wire cpu_mreq,input wire [15:0] cpu_addr,inout wire [7:0] cpu_data,output reg back_vram_wr_low,output wire [12:0] back_vram_addr,output wire [7:0] back_vram_data);reg [12:0] temp_vram_addr; 
 reg [12:0] temp_vram_data; 
 assign back_vram_addr = copy_in_progress ? 13'bzzzzzzzzzzzzz : temp_vram_addr; 
 assign back_vram_data = copy_in_progress ? 8'bzzzzzzzz : temp_vram_data; 
 always @(posedge cpu_clk) 
 begin 
  if(copy_in_progress == 0) begin 
  if(cpu_mreq == 0 && cpu_wr == 0) begin 
  temp_vram_addr = cpu_addr - 16'h8000; 
  temp_vram_data = cpu_data; 
  back_vram_wr_low = 0; 
  end 
  end 
  else begin 
  back_vram_wr_low = 1; 
  end 
 end 
 endmodule