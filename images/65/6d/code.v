module top_module(in,out);input [3:0]in;
output [3:0]out;
reg [3:0]out;
	always@(*)
	begin
		case(in)
			4'h0: out = 12;
			4'h1: out = 13;
			4'h2: out = 9;
			4'h3: out = 5;
			4'h4: out = 14;
			4'h5: out = 10;
			4'h6: out = 6;
			4'h7: out = 15;
			4'h8: out = 11;
			4'h9: out = 7;
			4'ha: out = 8;
			4'hb: out = 4;
			4'hc: out = 3;
			4'hd: out = 2;
			4'he: out = 1;
			4'hf: out = 0;
		endcase
	end
endmodule