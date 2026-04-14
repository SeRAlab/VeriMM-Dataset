module top_module(
input wire clk,           
input wire rst,			  
input wire [6:0] datain,  
output wire  dataout 	  
);reg [6:0] data;

always @(posedge clk)
	if(!rst)
		data <= datain;			
	else
		begin
			data[6] <= 1'b0;		
			data[5] <= data[6];
			data[4] <= data[5];
			data[3] <= data[4];
			data[2] <= data[3];
			data[1] <= data[2];
			data[0] <= data[1];     
		end
		
assign dataout = data[0];		

endmodule