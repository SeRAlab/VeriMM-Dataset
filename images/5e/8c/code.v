module top_module(
	input  [3 : 0] code_in,
       	output reg	[1 : 0] code_out
);reg flag;
	integer i;

	always@(code_in)
	begin
		
		
		flag = 0;
		for(i = 0; i <= 3; i = i + 1) begin
			if(code_in[i] && flag == 0) begin
				code_out = i;
				flag = 1;
			end	
		end
		
	end

endmodule