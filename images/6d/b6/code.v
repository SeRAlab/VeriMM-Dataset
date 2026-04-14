module top_module(X_in, sx, rst, clk, x_par, fx);input X_in, sx,rst,clk;
	output fx;
	output [11 - 1:0] x_par;
	wire fx; 

	reg [11 - 1:0] x_par;
	reg [3 : 0] shifts;
	
	assign fx = (shifts >= 11);

	always @(posedge clk or posedge rst) begin
		if(rst) begin
			x_par<= 11'b0;
			shifts<= 4'b0;
		end
		 else if(sx && shifts< 11) begin
			x_par[11-1:0]<={ x_par[11-2:0], X_in};
			shifts <= shifts + 1;
		end
		
	end
	
endmodule