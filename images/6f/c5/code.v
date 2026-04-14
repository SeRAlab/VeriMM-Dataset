module top_module(reset, clk, data, tx, rts, cts, end_flag);input  reset;
	input  clk;
	output tx;
	output [7:0] data;
	output rts;
	input cts;
	output end_flag;

	reg tx;
	reg [7:0] data;
	wire rts;
	reg end_flag;

	reg [7:0] buffer;
	reg [3:0] data_cnt;
	reg [4:0] multi_cnt;
	reg sending;
	reg start_bit;
	reg stop_bit;
	reg stop_bit_running;

	assign rts = ~sending;

	always @(negedge reset) begin
		buffer <= 8'b0;
		data <= 8'b0;
		multi_cnt <= 8'b0;
		sending <= 1'b0;
		end_flag <= 1'b0;
		tx <= 1'b1;
	end

	always @(posedge clk) begin
		if (reset) begin
			if (sending) begin
				multi_cnt <= multi_cnt + 5'b1;
				if (multi_cnt == 5'b11111) begin
					if (start_bit) begin
						tx <= 1'b0;
						start_bit <= 1'b0;
					end else if (stop_bit) begin
						if (stop_bit_running) begin
							sending <= 1'b0;
							data[7:0] <= data[7:0] + 8'b1;
							if (data[7:0] == 8'b11111111) begin
								end_flag <= 1'b1;
							end
						end else begin
							tx <= 1'b1;
							stop_bit_running <= 1'b1;
						end
					end else begin
						tx <= buffer[0];
						buffer[7:0] <= { 1'b0, buffer[7:1] };
						data_cnt <= data_cnt + 3'b1;
						if (data_cnt == 3'b111) begin
							stop_bit <= 1'b1;
							stop_bit_running <= 1'b0;
						end
					end
				end
			end else begin
				if (cts) begin
					sending <= 1'b1;
					multi_cnt <= 5'b0;
					start_bit <= 1'b1;
					stop_bit <= 1'b0;
					stop_bit_running <= 1'b0;
					data_cnt <= 3'b0;
					buffer[7:0] <= data[7:0];
				end
			end
		end
	end

endmodule