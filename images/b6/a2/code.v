module top_module(input a, input[6:0] b, input clk, input start, input done, output[13:0] out
    );reg [13:0] out1;
reg cy_out;
reg [6:0]sum ; 
assign out =out1;
always @(posedge clk)
begin
	if(start) 
	begin
		out1 = 14'b00000000000000;
	end
	else
	begin
		if(~done) 
		begin
			{cy_out,sum}=((a)?b:(7'b0000000))+out1[13:7]; 
			out1 = {((a)?b:(7'b0000000)),7'b0000000}+out1;  
			out1 = out1>>1; 											
			out1[13] = cy_out?1'b1:1'b0; 							
		end
		else
		out1 = 14'b00000000000000; 								
	end
end

endmodule