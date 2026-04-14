module top_module(input wire clock,input wire clock_debug,input wire reset,input wire WriteEnable,input wire [4:0] read_address_1,input wire [4:0] read_address_2,input wire [4:0] read_address_3,input wire [31:0] write_data_in,input wire [4:0] write_address,input wire [4:0] read_address_debug,output reg [31:0] data_out_1,output reg [31:0] data_out_2,output reg [31:0] data_out_3,output reg [31:0] data_out_debug);integer i; 
  reg [31:0] register[0:31]; 
  initial begin 
  for(i=0;i<32;i=i+1)begin 
  register[i] = i; 
  end 
  end 
  always @(posedge clock) begin 
  if(WriteEnable &&(write_address != 5'b0))begin 
  register[write_address] <= write_data_in; 
  end 
  if(reset)begin 
  for(i=0;i<32;i=i+1)begin 
  register[i] = i; 
  end 
  end 
  end 
  always @(negedge clock) begin 
  data_out_1 = register[read_address_1]; 
  data_out_2 = register[read_address_2]; 
  data_out_debug = register[read_address_debug]; 
  end 
 endmodule