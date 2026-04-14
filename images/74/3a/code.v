module top_module(
	Sel0,
	Data0x0, Data0x1, Data0x2, Data0x3,
	Data1x0, Data1x1, Data1x2, Data1x3,
	Result0, Result1, Result2, Result3
);input Sel0;
input Data0x0, Data0x1, Data0x2, Data0x3;
input Data1x0, Data1x1, Data1x2, Data1x3;
output Result0, Result1, Result2, Result3;
assign {Result0, Result1, Result2, Result3} = Sel0 ? {Data1x0, Data1x1, Data1x2, Data1x3} : {Data0x0, Data0x1, Data0x2, Data0x3};
endmodule