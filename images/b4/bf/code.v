module top_module(in,out);output reg [10:0] out;
	
	
	
	input [14:0] in;
	
	
	
	
	
	
	
	
	always @(*)
	begin
		out[0]=in[2];
		out[1]=in[4];
		out[2]=in[5];
		out[3]=in[6];
		out[4]=in[8];
		out[5]=in[9];
		out[6]=in[10];
		out[7]=in[11];
		out[8]=in[12];
		out[9]=in[13];
		out[10]=in[14];
	end
	
	
endmodule