module top_module(ln0, ln1, clk, reset, dataout
    );input ln0, ln1, clk, reset;
output reg [3:0] dataout;
reg lnt0, lnt1,l0,l1,ll0,ll1;

always @(posedge clk)
begin
	if (reset) dataout = 4'b0000;
	else if (lnt0) dataout = {1'b0, dataout[3:1]};
	else if (lnt1) dataout = {1'b1, dataout[3:1]};
	else dataout = dataout;
end

always @(posedge clk)
begin
	l0<=ln0;
	l1<=ln1;
end

always @(posedge clk)
begin
	ll0<=l0;
	ll1<=l1;
end

always @(posedge clk)
begin
	lnt0<=(l0&(~ll0));
	lnt1<=(l1&(~ll1));
end

endmodule