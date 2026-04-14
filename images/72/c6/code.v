module top_module(input [7:0] in, output [7:0] out1, out2, out3, out4);parameter p = 23;
	parameter px = 42;
	function [7:0] test1;
		input [7:0] i;
		parameter p = 42;
		begin
			test1 = i + p;
		end
	endfunction
	function [7:0] test2;
		input [7:0] i;
		parameter p2 = p+42;
		begin
			test2 = i + p2;
		end
	endfunction
	function [7:0] test3;
		input [7:0] i;
		begin
			test3 = i + p;
		end
	endfunction
	function [7:0] test4;
		input [7:0] i;
		parameter px = p + 13;
		parameter p3 = px - 37;
		parameter p4 = p3 ^ px;
		begin
			test4 = i + p4;
		end
	endfunction
	assign out1 = test1(in);
	assign out2 = test2(in);
	assign out3 = test3(in);
	assign out4 = test4(in);endmodule