module top_module(
	input D, clk, rst, pst,
	output reg Qsimple, Qasyncrst, Qasyncpst
	);always @(posedge clk)
	Qsimple <= D;

always @(posedge clk, posedge rst)begin
	if (rst == 1'b1)
		Qasyncrst <= 1'b0;
	else
		Qasyncrst <= D;
end

always @(posedge clk, posedge rst, posedge pst)begin
	if (rst == 1'b1)
		Qasyncpst <= 1'b0;
	else if (pst == 1'b1)
		Qasyncpst <= 1'b1;
	else
		Qasyncpst <= D;
end

endmodule