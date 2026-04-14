module top_module(input sys_clk,input count_rst,output [6:0] a_addr,output [6:0] b_addr,output [3:0] opcode,output [6:0] w_addr,input c_en,input [1:0] c_page,input [8:0] c_offset,output [31:0] c_do,input [31:0] c_di,input c_w_en,output [10:0] pc);wire [10:0] mem_a; 
 wire [24:0] mem_di; 
 reg [24:0] mem_do; 
 wire mem_we; 
 reg [24:0] mem[0:2047]; 
 always @(posedge sys_clk) begin 
  if(mem_we) 
  mem[mem_a] <= mem_di; 
  mem_do <= mem[mem_a]; 
 end 
 reg [10:0] counter; 
 always @(posedge sys_clk) begin 
  if(count_rst) 
  counter <= 10'd0; 
  else 
  counter <= counter + 10'd1; 
 end 
 assign mem_a = c_en ? {c_page, c_offset} : counter; 
 assign c_do = {7'd0, mem_do}; 
 assign mem_di = c_di[24:0]; 
 assign mem_we = c_en & c_w_en; 
 assign a_addr = mem_do[24:18]; 
 assign b_addr = mem_do[17:11]; 
 assign opcode = mem_do[10:7]; 
 assign w_addr = mem_do[6:0]; 
 assign pc = counter; 
 endmodule