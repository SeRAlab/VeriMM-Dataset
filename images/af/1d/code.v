module top_module(clk, rstn, datain_ch0, datain_ch1, datain_ch2, datain_ch3, serialout, testout0, testout1, testout2, testout3);input clk;
	input rstn;
	input datain_ch0;
	input datain_ch1;
	input datain_ch2;
	input datain_ch3;
	output serialout;
	output testout0;
	output testout1;
	output testout2;
	output testout3;
	
	reg [3:0] data;
	reg [3:0] test;

	always @(posedge clk or negedge rstn) begin
		if(!rstn) begin
			data <= 4'b0000;
			test <= 4'b0000;
		end else begin
			data <= {data[2:0], datain_ch3, datain_ch2, datain_ch1, datain_ch0};
			test <= {test[2:0], datain_ch3, datain_ch2, datain_ch1, datain_ch0};
		end
	end

	assign serialout = data[0];
	assign testout0 = test[0];
	assign testout1 = test[1];
	assign testout2 = test[2];
	assign testout3 = test[3];
endmodule