module top_module(input Cen, initOne, clk, rst, output [7:0]Out);reg [7:0] p;
	always@(posedge clk, posedge rst) begin
		if(rst) p <= 8'b0;
		else
			if(initOne) p <= 8'd1;
			else if(Cen) p <= p+1;
			else p <= p;
	end
	assign Out = p;
endmodule