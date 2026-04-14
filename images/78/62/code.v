module top_module(
		 input clock_recovery,
		 input clock_50,
		 input reset_n,
		 input [13:0] data_rec,
		 output reg [13:0] data_stand	
		);reg [13:0] prev_data_stand;

	always@(posedge clock_50 or negedge reset_n ) begin
		if(!reset_n) begin
			data_stand <= 14'd0;
			prev_data_stand <= 14'd0;
		end
		else begin
			if(clock_recovery) begin
				data_stand <= data_rec;
				prev_data_stand <= data_rec;
			end
			else begin
				data_stand <= prev_data_stand;
			end
		end
	end

endmodule