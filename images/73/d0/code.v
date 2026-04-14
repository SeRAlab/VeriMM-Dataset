module top_module(
	input sys_clk,
	input sys_rst,
	
	input [4:0] req,
	output [2:0] gnt
);reg [2:0] state;
reg [2:0] next_state;

assign gnt = state;

always @(posedge sys_clk) begin
	if(sys_rst)
		state <= 3'd0;
	else
		state <= next_state;
end

always @(*) begin
	next_state = state;
	case(state)
		3'd0: begin
			if(~req[0]) begin
				     if(req[1]) next_state = 3'd1;
				else if(req[2]) next_state = 3'd2;
				else if(req[3]) next_state = 3'd3;
				else if(req[4]) next_state = 3'd4;
			end
		end
		3'd1: begin
			if(~req[1]) begin
				     if(req[2]) next_state = 3'd2;
				else if(req[3]) next_state = 3'd3;
				else if(req[4]) next_state = 3'd4;
				else if(req[0]) next_state = 3'd0;
			end
		end
		3'd2: begin
			if(~req[2]) begin
				     if(req[3]) next_state = 3'd3;
				else if(req[4]) next_state = 3'd4;
				else if(req[0]) next_state = 3'd0;
				else if(req[1]) next_state = 3'd1;
			end
		end
		3'd3: begin
			if(~req[3]) begin
				     if(req[4]) next_state = 3'd4;
				else if(req[0]) next_state = 3'd0;
				else if(req[1]) next_state = 3'd1;
				else if(req[2]) next_state = 3'd2;
			end
		end
		3'd4: begin
			if(~req[4]) begin
				     if(req[0]) next_state = 3'd0;
				else if(req[1]) next_state = 3'd1;
				else if(req[2]) next_state = 3'd2;
				else if(req[3]) next_state = 3'd3;
			end
		end
	endcase
end

endmodule