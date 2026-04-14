module top_module(a,b,c,f1,f2
    );input a,b,c;
	output f1,f2;
	wire a,b,c;
	reg f1,f2;
	always@(a or b or c)
	begin 
		f2 = f1^f2;
		f1 = ~(a&b);

	end

endmodule