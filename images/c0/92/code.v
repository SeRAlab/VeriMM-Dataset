module arbiter_node (
	input enable,
	input [1:0] req,
	output [1:0] grant,
	output select,
	output valid,
	input clock,
	input reset
);
reg grant_state;
wire next_state;
assign grant[0] = req[0] & ~grant_state & enable;
assign grant[1] = req[1] & grant_state & enable;
assign select = grant_state;
assign valid = (req[0] & ~grant_state) | req[1];
assign next_state = (req[1] & ~req[0]) | (req[1] & grant_state);
always @(posedge clock, posedge reset)
begin
	if(reset)
		grant_state <= 0;
	else
		grant_state <= next_state;
end
endmodule