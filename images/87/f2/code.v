module top_module(clk, rota, rotb, rot_event, rot_direction);input clk, rota, rotb;
output rot_event, rot_direction;
reg rot_event = 1, rot_direction = 0;

always @(posedge clk) begin
	if(rota & rotb) 
		rot_event <= 1;
	else if(~rota & ~rotb)
		rot_event <= 0;
	else if(~rota & rotb)
		rot_direction <= 1;
	else
		rot_direction <= 0;
end

endmodule