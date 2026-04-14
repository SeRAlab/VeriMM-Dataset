module top_module(input [31:0] PC_in,input clk,output reg [31:0]PC_out);reg [31:0]PC_in_r; 
 initial 
 PC_out=32'b0; 
 always@(posedge clk) 
 begin 
 PC_out<=PC_in; 
 end 
 endmodule