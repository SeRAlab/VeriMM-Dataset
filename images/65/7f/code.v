module top_module(
	input clk,
	input rst,

	input [23:0] din_data,
	input din_valid,
	output wire din_ready,
	input wire din_sop,
	input wire din_eop,
	
	output wire [DATA_WIDTH-1:0] data_fifo_out,
	output wire data_valid_fifo_out,
	input wire [FIFO_DEPTH_LOG2:0] usedw_fifo_out,
	
	input start,
	output endf
);parameter DATA_WIDTH = 32;
	parameter FIFO_DEPTH = 256;
	parameter FIFO_DEPTH_LOG2 = 8;

	reg video_reg;
	wire set_video;
	wire reset_video;
	
	reg [1:0] run;

	always @ (posedge clk) begin
		if (start == 1) begin
			video_reg <= 0;
		end	else begin
			if (reset_video == 1) begin
				video_reg <= 0;
			end 
			if (set_video == 1) begin
				video_reg <= 1;
			end 
		end
	end
	
	always @ (posedge clk or posedge rst) begin
		if (rst == 1) begin
			run <= 0;
		end else begin
			if (start == 1) begin
				run <= 1;
			end else begin
				if (reset_video == 1) begin
					run <= 2;
				end
				if (endf == 1) begin
					run <= 0;
				end
			end
		end
	end
	
	assign set_video = (din_sop == 1) & (din_data == 0) & (din_valid == 1) & (run == 1);
	assign reset_video = (din_eop == 1) & (din_valid == 1) & (video_reg == 1);
	
	assign data_fifo_out = {8'd0, din_data};
	assign data_valid_fifo_out = (video_reg == 1) & (din_valid == 1) & (run == 1);

	assign din_ready = (usedw_fifo_out < (FIFO_DEPTH - 1));
	
	assign endf = (run == 2);
   
endmodule