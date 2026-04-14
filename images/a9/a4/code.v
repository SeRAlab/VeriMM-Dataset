module top_module(
	Sel0,
	Data0x0,
	Data1x0,
	Result0
);input Sel0;
input Data0x0;
input Data1x0;
output Result0;
assign Result0 = Sel0 ? Data1x0 : Data0x0;
endmodule