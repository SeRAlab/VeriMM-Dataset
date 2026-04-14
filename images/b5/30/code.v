module top_module(w_bus_addr_pc_out, w_bus_jump_addr, w_channel, w_clock, w_reset);output [7:0] w_bus_addr_pc_out;
	input [7:0] w_bus_jump_addr;
	input w_channel, w_clock, w_reset;

	reg [7:0] w_bus_addr_pc;

	always @(posedge w_clock) begin
		if (w_reset) begin
			w_bus_addr_pc <= 8'h00;
		end else if (w_channel) begin
			w_bus_addr_pc <= w_bus_jump_addr;
		end else begin
			w_bus_addr_pc <= w_bus_addr_pc + 1;
		end
	end

	assign w_bus_addr_pc_out = w_bus_addr_pc;
endmodule