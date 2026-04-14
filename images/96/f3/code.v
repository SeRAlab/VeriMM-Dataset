module top_module(
	input clk,
	input [15:0] data_in,
	output reg hs_de,
	output reg vs_de,
	output reg [15:0] data_out
);reg [15:0] data_d = 'd0;
	reg hs_de_rcv_d = 'd0;
	reg vs_de_rcv_d = 'd0;
	reg [15:0] data_2d = 'd0;
	reg hs_de_rcv_2d = 'd0;
	reg vs_de_rcv_2d = 'd0;
	reg [15:0] data_3d = 'd0;
	reg hs_de_rcv_3d = 'd0;
	reg vs_de_rcv_3d = 'd0;
	reg [15:0] data_4d = 'd0;
	reg hs_de_rcv_4d = 'd0;
	reg vs_de_rcv_4d = 'd0;
	reg hs_de_rcv = 'd0;
	reg vs_de_rcv = 'd0;

	
	always @(posedge clk) begin
		data_d <= data_in;
		data_2d <= data_d;
		data_3d <= data_2d;
		data_4d <= data_3d;
		data_out <= data_4d;

		hs_de_rcv_d <= hs_de_rcv;
		vs_de_rcv_d <= vs_de_rcv;
		hs_de_rcv_2d <= hs_de_rcv_d;
		vs_de_rcv_2d <= vs_de_rcv_d;
		hs_de_rcv_3d <= hs_de_rcv_2d;
		vs_de_rcv_3d <= vs_de_rcv_2d;
		hs_de_rcv_4d <= hs_de_rcv_3d;
		vs_de_rcv_4d <= vs_de_rcv_3d;
		hs_de <= hs_de_rcv & hs_de_rcv_4d;
		vs_de <= vs_de_rcv & vs_de_rcv_4d;
	end

	reg [1:0] preamble_cnt = 'd0;
		
	
	always @(posedge clk) begin
		if ((data_in == 16'hffff) || (data_in == 16'h0000)) begin
			preamble_cnt <= preamble_cnt + 1'b1;
		end else begin
			preamble_cnt <= 'd0;
		end
	
		if (preamble_cnt == 3'h3) begin
			if ((data_in == 16'hb6b6) || (data_in == 16'h9d9d)) begin
				hs_de_rcv <= 1'b0;
				vs_de_rcv <= ~data_in[13];
			end else if ((data_in == 16'habab) || (data_in == 16'h8080)) begin
				hs_de_rcv <= 1'b1;
				vs_de_rcv <= ~data_in[13];
			end
		end
	end

endmodule