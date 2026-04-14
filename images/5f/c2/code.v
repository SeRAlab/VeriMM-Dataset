module top_module(
    input i_clk,
    input i_reset,
    input i_val,
    input [7:0] i_neighbours,
    output reg o_val
);parameter [8:0] LIVE_STATE = 9'b000001000;
	parameter [8:0] DIE_STATE  = 9'b111110011;
	integer v_num_neighbours;
	integer i;

	always @(posedge i_clk) begin
		if(i_reset) begin
			o_val <= i_val;
		end
		else begin
			v_num_neighbours = 0;
			for(i = 0; i < 8; i=i+1) begin
				v_num_neighbours = v_num_neighbours + i_neighbours[i];
			end

			if(LIVE_STATE[v_num_neighbours])
				o_val <= 1;
			if (DIE_STATE[v_num_neighbours])
				o_val <= 0;
		end
	end
endmodule