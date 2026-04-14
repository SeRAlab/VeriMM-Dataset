module top_module(input[7:0]a,
					 input[7:0]b,
					 input sel,
					 output reg[7:0]o
					 );always@*begin
		if(sel == 1) o <= b;
		else o <= a;
	end
endmodule