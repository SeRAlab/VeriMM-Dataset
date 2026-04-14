module top_module(
	output reg     out,
	input       address,
	input  input1,
	input input2
);always @* begin
     
		 if (address == 0)
		 	out<=input1;
		else
			out<=input2;

end

endmodule