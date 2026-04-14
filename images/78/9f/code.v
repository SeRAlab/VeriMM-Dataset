module top_module(input wire i_clk,input wire i_reset,input wire i_wen,input wire [5:0] i_wr_addr_a,input wire [5:0] i_wr_addr_b,input wire [31:0] i_wr_data_a,input wire [31:0] i_wr_data_b,input wire [5:0] i_rd_addr_a,input wire [5:0] i_rd_addr_b,input wire [5:0] i_rd_addr_c,input wire [5:0] i_rd_addr_d,output reg [31:0] o_rd_data_a,output reg [31:0] o_rd_data_b,output reg [31:0] o_rd_data_c,output reg [31:0] o_rd_data_d);integer i; 
 reg [31:0] mem [39:0]; 
 always @ ( posedge i_clk ) 
 begin 
  if ( i_reset ) 
  begin 
  for(i=0;i<40;i=i+1) 
  begin 
  mem[i] <= 32'd0; 
  end 
  end 
  else if ( i_wen ) 
  begin 
  mem [ i_wr_addr_a ] <= i_wr_data_a; 
  mem [ i_wr_addr_b ] <= i_wr_data_b; 
  end 
 end 
 always @* 
 begin 
  o_rd_data_a = mem [ i_rd_addr_a ]; 
  o_rd_data_b = mem [ i_rd_addr_b ]; 
  o_rd_data_c = mem [ i_rd_addr_c ]; 
  o_rd_data_d = mem [ i_rd_addr_d ]; 
 end 
 endmodule