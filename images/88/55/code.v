module top_module(input select,input enable_0,input command_0,input [31:0] address_0,input [31:0] write_data_0,input [3:0] write_mask_0,output [31:0] read_data_0,output valid_0,input enable_1,input command_1,input [31:0] address_1,input [31:0] write_data_1,input [3:0] write_mask_1,output [31:0] read_data_1,output valid_1,output enable,output command,output [31:0] address,output [31:0] write_data,output [3:0] write_mask,input [31:0] read_data,input valid);assign enable = select ? enable_1 : enable_0; 
  assign command = select ? command_1 : command_0; 
  assign address = select ? address_1 : address_0; 
  assign write_data = select ? write_data_1 : write_data_0; 
  assign write_mask = select ? write_mask_1 : write_mask_0; 
  assign read_data_1 = read_data; 
  assign read_data_0 = read_data; 
  assign valid_1 = select ? valid : 1'b0; 
  assign valid_0 = !select ? valid : 1'b0; 
 endmodule