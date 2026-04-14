module top_module(
	input clk,
	input sync,
	input reset,

	input write,
	input [31:0]writedata,
	input [3:0]address,

	output reg [31:0]reg0,
	output reg [31:0]reg1,
	output reg [31:0]reg2,
	output reg [31:0]reg3,
	output reg [31:0]reg4,
	output reg [31:0]reg5,
	output reg [31:0]reg6
);always @(posedge clk or posedge reset)
	begin
		if (reset) reg0 <= 0;
		else if (write && (address == 4'd0)) reg0 <= writedata;
	end

	
	reg [31:0]pulse1;
	always @(posedge clk or posedge reset)
	begin
		if (reset)
		begin
			pulse1 <= 0;
			reg1   <= 0;
		end
		else
		begin
			if (write && (address == 4'd1)) pulse1 <= pulse1 | writedata;
			else
			begin
				if (sync) reg1 <= pulse1;
				pulse1 <= pulse1 & ~reg1;
			end
		end
	end

	
	always @(posedge clk or posedge reset)
	begin
		if (reset) reg2 <= 0;
		else if (write && (address == 4'd2)) reg2 <= writedata;
	end

	
	always @(posedge clk or posedge reset)
	begin
		if (reset) reg3 <= 0;
		else if (write && (address == 4'd3)) reg3 <= writedata;
	end

	
	always @(posedge clk or posedge reset)
	begin
		if (reset) reg4 <= 0;
		else if (write && (address == 4'd4)) reg4 <= writedata;
	end

	
	always @(posedge clk or posedge reset)
	begin
		if (reset) reg5 <= 0;
		else if (write && (address == 4'd5)) reg5 <= writedata;
	end

	
	always @(posedge clk or posedge reset)
	begin
		if (reset) reg6 <= 0;
		else if (write && (address == 4'd6)) reg6 <= writedata;
	end

endmodule