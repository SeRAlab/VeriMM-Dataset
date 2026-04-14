module top_module(out, M, in, clk, rst);output reg [31:0] out;
	
	input  [7:0] M;
	input  [7:0] in;
	input  clk;
	input  rst;
	
	reg [31:0] C;
	
	reg [31:0] C0;
	
	reg [7:0] N;
	reg [7:0] i;
	
	always@(posedge clk, posedge rst)
	begin
	
	if (rst)
		begin
		C <= 0; C0 <= 0; N <= 0; out <= 0; i <= 0;
		end
		
	else
		begin
		if (i < M)
			begin
				if (i == 0) C0 <= in;
				N <= (N + in)/2;
				C <= (C + (N + in)/2);
				i <= i + 1;
			end
		else
			begin
			out <= (C - ((C0 + N)/2))/(C0 - N);
			i <= M;
			end
		end
	end

endmodule