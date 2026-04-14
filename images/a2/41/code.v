module top_module(CLK, RESET, bus_01047762_);input		CLK;
input		RESET;
output		bus_01047762_;
reg		kicker_2=1'h0;
wire		bus_01506130_;
reg		kicker_res=1'h0;
wire		bus_01e79d73_;
reg		kicker_1=1'h0;
wire		bus_00a57644_;
wire		bus_011883db_;
always @(posedge CLK)
begin
kicker_2<=bus_00a57644_;
end
assign bus_01506130_=~RESET;
always @(posedge CLK)
begin
kicker_res<=bus_01e79d73_;
end
assign bus_01e79d73_=kicker_1&bus_01506130_&bus_011883db_;
always @(posedge CLK)
begin
kicker_1<=bus_01506130_;
end
assign bus_01047762_=kicker_res;
assign bus_00a57644_=bus_01506130_&kicker_1;
assign bus_011883db_=~kicker_2;endmodule