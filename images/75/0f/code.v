module top_module(input wire clk,input wire api_wr,input wire [07 : 0] api_addr,input wire [31 : 0] api_wr_data,output wire [31 : 0] api_rd_data,input wire [06 : 0] internal_addr,output wire [63 : 0] internal_rd_data);reg [31 : 0] mem0 [0 : 127]; 
  reg [31 : 0] mem1 [0 : 127]; 
  wire mem0_we; 
  wire mem1_we; 
  reg [31 : 0] tmp0_api_rd_data; 
  reg [31 : 0] tmp1_api_rd_data; 
  reg [31 : 0] tmp0_int_rd_data; 
  reg [31 : 0] tmp1_int_rd_data; 
  assign api_rd_data = api_addr[0] ? tmp1_api_rd_data : tmp0_api_rd_data; 
  assign internal_rd_data = {tmp1_int_rd_data, tmp0_int_rd_data}; 
  assign mem0_we = api_wr & ~api_addr[0]; 
  assign mem1_we = api_wr & api_addr[0]; 
  always @ (posedge clk) 
  begin : reg_update_mem0 
  if (mem0_we) 
  mem0[api_addr[7 : 1]] <= api_wr_data; 
  tmp0_api_rd_data <= mem0[api_addr[7 : 1]]; 
  tmp0_int_rd_data <= mem0[internal_addr]; 
  end 
  always @ (posedge clk) 
  begin : reg_update_mem1 
  if (mem1_we) 
  mem1[api_addr[7 : 1]] <= api_wr_data; 
  tmp1_api_rd_data <= mem1[api_addr[7 : 1]]; 
  tmp1_int_rd_data <= mem1[internal_addr]; 
  end 
 endmodule