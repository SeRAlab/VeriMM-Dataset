module pulse_stretcher(
	input clk,
	input rst_n,
	input din_pulse,
	output reg dout_pulse
);

	reg [1:0] cnt;
	reg pulse_active;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			cnt <= 2'b0;
			pulse_active <= 1'b0;
		end
		else if (din_pulse) begin
			cnt <= 2'b11; // Set counter to 3 to get 4 cycles
			pulse_active <= 1'b1;
		end
		else if (pulse_active) begin
			if (cnt == 2'b0)
				pulse_active <= 1'b0;
			else
				cnt <= cnt - 1'b1;
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			dout_pulse <= 1'b0;
		else
			dout_pulse <= pulse_active;
	end

endmodule