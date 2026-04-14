module top_module(ps2_clk, ps2_data, ps2_code, ps2_up, ps2_ext, ps2_event);input wire ps2_clk, ps2_data;
	output reg[7:0] ps2_code = 0;
	output reg ps2_up = 0, ps2_ext = 0, ps2_event = 0;
	
	reg[10:0] shreg = 11'b11111111111;
	wire[10:0] shnew = {ps2_data, shreg[10:1]};
	wire start = shnew[0], stop = shnew[10], parity = shnew[9];
	wire[7:0] data = shnew[8:1];
	
	always @(negedge ps2_clk) begin
		if (!start && stop && (parity == ~^data)) begin
			if (data == 8'hE0) begin
				ps2_ext <= 1;
			end else if (data == 8'hF0) begin
				ps2_up <= 1;
			end else begin
				ps2_code <= data;
				ps2_event <= 1;
			end
			shreg <= 11'b11111111111;
		end else begin
			if (ps2_event) begin
				ps2_up <= 0;
				ps2_ext <= 0;
				ps2_event <= 0;
			end
			shreg <= shnew;
		end
	end
endmodule