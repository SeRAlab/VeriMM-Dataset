module top_module(
		output o,
		input [1:0]s,
		input i0,i1,i2,i3);assign o=(s==0)?i0:((s==1)?i1:((s==2)?i2:i3));
endmodule