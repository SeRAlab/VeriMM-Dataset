module top_module(count, lane, Mod);input count;
	input[1:0] lane;
	output[1:0]Mod;
	
	assign Mod[1] = (~count & lane[1]) | (lane[1] & ~lane[0])| (count & ~lane[1] & lane[0]);
	assign Mod[0] = (~count & lane[0]) | (count & ~lane[0]);
	
endmodule