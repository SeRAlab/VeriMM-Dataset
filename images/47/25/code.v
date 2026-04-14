module top_module(
	 input clk,
    input rst,
	 input select,
    output reg [31:0] OUT1,
	 output reg [31:0] OUT2,
    output clkdivided1hz,
	 output clkdivided200hz,
	 output clkselect
    );always @ (posedge clk or posedge rst)
		begin
		if (rst)
			OUT1<=32'd0;
		else
		if (OUT1 == 32'd50000000)
			OUT1<=32'd0;
		else
			OUT1 <= OUT1 + 1;
		end
		
	 always @ (posedge clk or posedge rst)
		begin
		if (rst)
			OUT2<=32'd0;
		else
		if (OUT2 == 32'd500000)
			OUT2<=32'd0;
		else
			OUT2 <= OUT2 + 1;
		end
assign clkdivided1hz = (OUT1 == 32'd50000000);
assign clkdivided200hz = (OUT2 == 32'd250000);

assign clkselect  = clkdivided200hz;
endmodule