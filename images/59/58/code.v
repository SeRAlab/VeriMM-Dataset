module top_module(
    input clk,
    input start,
    input stop,
	 input reset,
    output reg miniscope_trig, 
    input miniscope_sync,
    output reg [31:0] frame_count = 32'd0
    );localparam S_IDLE = 2'd0;
localparam S_RECORD = 2'd1;
localparam S_DONE = 2'd2;
reg [1:0] state = S_IDLE;

reg [1:0] miniscope_sync_s = 2'b0;

always @ (posedge clk)
begin
	miniscope_sync_s <= {miniscope_sync, miniscope_sync_s[1]};
	
	if (reset)
		frame_count <= 32'd0;
	else
	begin
		if (miniscope_sync_s[1] & (~miniscope_sync_s[0])) 
			frame_count <= frame_count + 1;
		case (state)
			S_IDLE:
			if (start)
			begin
				miniscope_trig <= 1'b1; 
				state <= S_RECORD;
			end
			
			S_RECORD:
			if (stop)
			begin
				miniscope_trig <= 1'b0; 
				state <= S_IDLE;
			end
			
			S_DONE:
			begin
			
			end
		endcase
	end
end

endmodule