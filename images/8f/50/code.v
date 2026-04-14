module top_module(clk8x, data_frame, shift_enable, sdo, frame_sync);input wire clk8x;
	input wire [255:0] data_frame;
	input wire shift_enable;
	output reg sdo;
	output reg frame_sync;
	
	reg [255:0] shift_out = 256'd0;
	reg [7:0] bit_count = 8'd0;	
	
	
	always @ (posedge clk8x) begin
		frame_sync <= 0;
		if (shift_enable) begin
			
			if (bit_count == 0) begin
				shift_out <= data_frame;
				
				
				frame_sync <= 1;
			end
			else begin
				shift_out[255:1] <= shift_out[254:0];
			end
			
			
			sdo <= sdo ^ shift_out[255];
			
			bit_count <= bit_count + 1;
		end
	end
endmodule