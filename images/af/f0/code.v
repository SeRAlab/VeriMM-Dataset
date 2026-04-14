module top_module(
	input CLKI, RST, ALIGNWD,
	output CDIVX
);parameter GSR = "DISABLED";
	parameter DIV = "2.0";
	
	reg [1:0] count;
	reg [1:0] div_factor;
	reg out_reg;
	
	always @(posedge CLKI or posedge RST) begin
		if(RST) begin
			count <= 2'b00;
			out_reg <= 1'b0;
		end
		else begin
			if(GSR == "ENABLED" && ALIGNWD == 1'b0) begin
				count <= 2'b00;
				out_reg <= 1'b0;
			end
			else begin
				count <= count + 1;
				if(count == div_factor) begin
					count <= 2'b00;
					out_reg <= ~out_reg;
				end
			end
		end
	end
	
	assign CDIVX = out_reg;
	
	// Set div_factor based on DIV parameter
	initial begin
		case(DIV)
			"2.0": div_factor = 2'b01;
			"4.0": div_factor = 2'b10;
			"8.0": div_factor = 2'b11;
			default: div_factor = 2'b01;
		endcase
	end
endmodule