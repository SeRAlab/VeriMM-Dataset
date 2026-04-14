module top_module(
  input clock, in_ready, reset,
  input signed [15:0] data,
  output signed [15:0] avg,
  output avg_ready
);reg signed [15:0] samples [31:0];
	
	reg [4:0] offset = 0;
	reg signed [15:0] accum = 0;
	reg [5:0] num_samples = 0;
	reg signed [15:0] data_right_shift;
	
	always @(*) begin
		data_right_shift = {data[15], data[15], data[15], data[15],
			data[15], data[15:5]};
	end
	
	always @(posedge clock) begin
		if (reset) begin
			accum <= 0;
			num_samples <= 0;
			offset <= 0;
		end
		else if (in_ready) begin
			num_samples <= (num_samples == 6'd32) ? num_samples : num_samples + 1;
			samples[offset] <= data_right_shift;
			if (num_samples == 6'd32) begin
				accum <= accum + data_right_shift - samples[offset];
			end
			else begin
				accum <= accum + data_right_shift;
			end
			offset <= offset + 1;
		end
	end
  
  assign avg = accum;
  assign avg_ready = (num_samples == 6'd32) ? 1 : 0;
endmodule