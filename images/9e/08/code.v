module top_module(inA,inB,sub,out);parameter n = 8;
	input [n-1:0]inA,inB;
	input sub;
	output [n-1:0]out;
	
assign out = sub? (inA-inB) : (inA+inB);

endmodule