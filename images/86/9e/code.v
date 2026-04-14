module top_module(rst, clk, enable, zero, min, sec, msec);input rst, clk;
	input enable, zero;
	
	output [6:0] min, sec;
	reg [6:0] min, sec;
	
	output [14:0] msec;
	reg [14:0] msec;
	
	always @(posedge clk) begin
		if (~rst) msec = 0;
		else begin
			if (enable) begin
				if (msec >= 999) msec = 0;
				else msec = msec + 1;
			end else if (zero) begin
				msec = 0;
			end
		end
	end
	
	always @(posedge clk) begin
		if (~rst) sec = 0;
		else begin
			if (enable && (msec == 999)) begin
				if (sec == 59) sec = 0;
				else sec = sec + 1;
			end else if (zero) begin
				sec = 0;
			end
		end
	end
	
	always @(posedge clk) begin
		if (~rst) min = 0;
		else begin
			if (enable && (sec == 59) && (msec == 999)) begin
				if (min == 63) min = 0;
				else min = min + 1;
			end else if (zero) begin
				min = 0;
			end
		end
	end
endmodule