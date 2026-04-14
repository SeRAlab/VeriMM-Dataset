module top_module(
	input wire rst,
	input wire clk,
	output reg blank_n,
	output reg hs,
	output reg vs
);parameter hori_line    = 800;                           
	parameter hori_back    = 144;
	parameter hori_front   = 16;
	parameter vert_line    = 525;
	parameter vert_back    = 34;
	parameter vert_front   = 11;
	parameter H_sync_cycle = 96;
	parameter V_sync_cycle = 2;

	reg  [10:0] h_cnt;
	reg  [9:0]  v_cnt;
	wire        c_hd, c_vd, c_blank_n;
	wire        h_valid, v_valid;

	always @ (negedge clk, posedge rst) begin
		if (rst) begin
			h_cnt <= 0;
			v_cnt <= 0;
		end
		else begin
			if (h_cnt == hori_line - 1) begin 
				h_cnt <= 0;
				if (v_cnt == vert_line - 1)
					v_cnt <= 0;
				else
					v_cnt <= v_cnt + 1;
			end
			else
				h_cnt <= h_cnt + 1;
		end
	end

	assign c_hd = (h_cnt < H_sync_cycle) ? 0 : 1;
	assign c_vd = (v_cnt < V_sync_cycle) ? 0 : 1;

	assign h_valid = (h_cnt < (hori_line-hori_front) && h_cnt >= hori_back) ? 1 : 0;
	assign v_valid = (v_cnt < (vert_line-vert_front) && v_cnt >= vert_back) ? 1 : 0;

	assign c_blank_n = h_valid && v_valid;

	always @ (negedge clk) begin
		hs <= c_hd;
		vs <= c_vd;
		blank_n <= c_blank_n;
	end

endmodule