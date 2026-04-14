module top_module(rst, clk, we, src0, src1, dst, data ,data0, data1);input rst, clk, we;
	input [3:0] src0, src1,  dst;
	input [7:0] data;
	output [7:0] data0, data1;

	reg [7:0] regis [15:0];

	integer i;

	always @(posedge clk) begin
		if(rst == 1'b1) begin
			for(i=0; i<=15; i=i+1)
				regis[i] <= 0;
		end else if(we == 1'b1) begin
			regis[dst] <= data;
		end else begin
			regis[dst] <= regis[dst];
		end
	end

	assign data0 = regis[src0];
	assign data1 = regis[src1];

endmodule