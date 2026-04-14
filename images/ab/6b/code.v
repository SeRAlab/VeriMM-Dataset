module top_module(
	input clk,
	input reset,

	
	input avs_ctrl_write,
	input [31:0]avs_ctrl_writedata,
	input avs_ctrl_address,

	
	input sync,
	input [3:0]trigger,
	output reg enable,
	output write,
	output [15:0]data
);reg [13:0]count;

	assign write = (|trigger[2:0]) && sync && enable;
	assign data = {trigger[2], trigger[1], count};

	always @(posedge clk or posedge reset)
	begin
		if (reset)
		begin
			enable <= 0;
			count  <= 0;
		end
		else
		begin
			if (avs_ctrl_write)
			begin
				if (avs_ctrl_address)
				begin
					if (!enable) count <= avs_ctrl_writedata[13:0];
				end
				else enable <= avs_ctrl_writedata[0];
			end

			if (enable && sync)
			begin
				if (trigger[3]) count <= 0;
				else if (write) count <= count + 1;
			end
		end
	end


endmodule