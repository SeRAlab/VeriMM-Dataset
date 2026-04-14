module top_module(in1, in2, result_flags);input [31:0] in1,in2;
output reg [3:0] result_flags; 
reg [31:0] tmp_result;
 
 

 always @*
 begin
	
	
 	tmp_result = in1 - in2;

	
 	result_flags[3] = tmp_result[31];
	
	
 	if (in1 > in2)
	begin	
 		result_flags[1] = 1'b1;
	end
 	else 
	begin
 		result_flags[1] = 1'b0;
 	end	

	
 	if (tmp_result == 32'b0)
	begin
 		result_flags[2] = 1'b1;
	end
 	else
	begin
 		result_flags[2] = 1'b0;
	end

	
 	result_flags[0] = 1'b0;

 end
endmodule