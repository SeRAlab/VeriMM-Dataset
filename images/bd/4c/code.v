module top_module(input wire clk,input wire reset_n,input wire [07 : 0] read_addr0,output wire [31 : 0] read_data0,output wire [31 : 0] read_data1,input wire rst,input wire cs,input wire wr,input wire [31 : 0] write_data);reg [31 : 0] mem [0 : 255]; 
  reg [31 : 0] tmp_read_data0; 
  reg [31 : 0] tmp_read_data1; 
  reg [7 : 0] ptr_reg; 
  reg [7 : 0] ptr_new; 
  reg ptr_we; 
  assign read_data0 = tmp_read_data0; 
  assign read_data1 = tmp_read_data1; 
  always @ (posedge clk) 
  begin : mem_update 
  if (wr) 
  mem[ptr_reg] <= write_data; 
  tmp_read_data0 <= mem[read_addr0]; 
  tmp_read_data1 <= mem[ptr_reg]; 
  end 
  always @ (posedge clk or negedge reset_n) 
  begin : reg_mem_update 
  if (!reset_n) 
  ptr_reg <= 8'h00; 
  else 
  if (ptr_we) 
  ptr_reg <= ptr_new; 
  end 
  always @* 
  begin : ptr_logic 
  ptr_new = 8'h00; 
  ptr_we = 1'b0; 
  if (rst) 
  begin 
  ptr_new = 8'h00; 
  ptr_we = 1'b1; 
  end 
  if (cs) 
  begin 
  ptr_new = ptr_reg + 1'b1; 
  ptr_we = 1'b1; 
  end 
  end 
 endmodule