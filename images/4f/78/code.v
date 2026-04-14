module top_module(clk,rot_a,rot_b,rot_event,rot_dir
    );input clk,rot_a,rot_b;
output rot_event,rot_dir;
reg rot_event,rot_dir;
always @(posedge clk) begin
	if(rot_a == 1 & rot_b==1)
		rot_event <= 1;
	if(rot_a == 0 & rot_b==0)
		rot_event <= 0;
	if(rot_a == 0 & rot_b==1)
		rot_dir <= 1;
	if(rot_a == 1 & rot_b==0)
		rot_dir <= 0;
end

endmodule