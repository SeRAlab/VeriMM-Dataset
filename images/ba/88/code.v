module top_module(input clk,input [1:0] control_wb_in,input [31:0] Read_data_in,input [31:0] ALU_result_in,input [4:0] Write_reg_in,output reg [1:0] mem_control_wb,output reg [31:0] Read_data,output reg [31:0] mem_ALU_result,output reg [4:0] mem_Write_reg);initial 
  begin 
  mem_control_wb <= 0; 
  Read_data <= 0; 
  mem_ALU_result <= 0; 
  mem_Write_reg <= 0; 
  end 
  always @ (posedge clk) 
  begin 
  mem_control_wb <= control_wb_in; 
  Read_data <= Read_data_in; 
  mem_ALU_result <= ALU_result_in; 
  mem_Write_reg <= Write_reg_in; 
  end 
 endmodule