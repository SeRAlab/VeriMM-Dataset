module top_module(
	Clock, Enable,
	Data0, Data1, Data2, Data3,
	Q0, Q1, Q2, Q3
);input Clock, Enable;
input Data0, Data1, Data2, Data3;
output reg Q0, Q1, Q2, Q3;
always @(posedge Clock)
	if (Enable)
		{Q0, Q1, Q2, Q3} <= {Data0, Data1, Data2, Data3};
endmodule