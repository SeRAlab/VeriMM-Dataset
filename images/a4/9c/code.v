module top_module(
	input clk, // 12 MHz base clock
	input RS232_Rx, // Receive pin for the FTDI chip
	input resetn, // Reset the cycle
	output reg RS232_Tx, // Transmit pin for the FTDI chip
	output reg Pulse, // Output pin for the switch
	output reg Sync, // Output pin for the SYNC pulse
	output reg P2 // Output signal
);reg [31:0] counter;
	reg block;

	// generate sync pulse every 1000 clock cycles
	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			Sync <= 0;
			counter <= 0;
		end else begin
			if (counter == 1000 - 1) begin
				Sync <= 1;
				counter <= 0;
			end else begin
				Sync <= 0;
				counter <= counter + 1;
			end
		end
	end

	// generate pulse every 2000 clock cycles
	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			Pulse <= 0;
			counter <= 0;
		end else begin
			if (counter == 2000 - 1) begin
				Pulse <= 1;
				counter <= 0;
			end else begin
				Pulse <= 0;
				counter <= counter + 1;
			end
		end
	end

	// generate block signal every 5000 clock cycles
	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			block <= 0;
			counter <= 0;
		end else begin
			if (counter == 5000 - 1) begin
				block <= 1;
				counter <= 0;
			end else begin
				block <= 0;
				counter <= counter + 1;
			end
		end
	end

	// generate P2 signal every 3000 clock cycles
	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			P2 <= 0;
			counter <= 0;
		end else begin
			if (counter == 3000 - 1) begin
				P2 <= 1;
				counter <= 0;
			end else begin
				P2 <= 0;
				counter <= counter + 1;
			end
		end
	end

	// pass RS232_Rx through to RS232_Tx
	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			RS232_Tx <= 0;
		end else begin
			RS232_Tx <= RS232_Rx;
		end
	end

endmodule