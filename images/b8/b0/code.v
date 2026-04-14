module top_module(a, b, cou, result);input[7:0]	a, b;
	output[7:0]	result;
	output		cou;
	
	reg			cou;
	
	always @ (a or b)
	begin
		if ( a > b )
			cou = 1;
		else
			cou = 0;
	end
	
	assign result = a - b;endmodule