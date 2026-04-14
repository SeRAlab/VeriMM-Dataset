module top_module(output reg [7:0] result_im, result_re, input [7:0] a,b);reg [7:0] temp1,temp2;
	always @(*)
	begin
		temp1 = a[7:4] * b[3:0];
		temp2 = a[3:0] * b[7:4];
		result_im = temp1 + temp2;
		temp1 = a[3:0] * b[3:0];
		temp2 = a[7:4] * b[7:4];
		result_re = temp2 - temp1;
	end
endmodule