module top_module(
	clk,
	reset,
	selpc,
	d_mux_1,
	pc_4,
	pc_out
);parameter DLY_FF = 1;
	
	
	
	
	input clk;
	input	reset;
	input selpc;
	input [31:0] d_mux_1;
	output [14:0] pc_out;
	output [14:0] pc_4;

	
	
	
	reg [31:0] pc_reg;
	reg [31:0] mux_out;

	
	
	
	always @ (posedge clk or posedge reset) begin 
		if (reset == 1'b1) begin
			pc_reg	<=	#DLY_FF 15'b0;
		end
		else begin
			pc_reg	<=	#DLY_FF mux_out;
		end
	end

	always @ (*) begin 
		if (selpc == 1'b0) begin
			mux_out = pc_reg + 15'd4;
		end
		else begin
			mux_out = d_mux_1;
		end
	end

	
	
	
	assign pc_out = pc_reg[14:0];
	assign pc_4 = pc_reg[14:0] + 15'd4;

endmodule