module top_module(Colors, DisplayColors, SetColors, ColorOut, clk, reset);output reg SetColors;
	output reg [1:0] ColorOut;
	input [31:0] Colors;
	input DisplayColors, clk, reset;
	reg [5:0] CurrentEnd, CurrentColor;
	
	always @ (posedge clk) begin 
		if (reset) 
		begin
			SetColors <= 0;
			CurrentEnd <= 1;
			CurrentColor <= 1;
		end	
		else
		begin
			ColorOut <= {Colors[CurrentColor], Colors[CurrentColor-1]};
			SetColors <= 1;
		end
	end
	
	always @ (posedge clk) begin 
		if (CurrentColor >= CurrentEnd)
		begin
			CurrentEnd <= CurrentEnd + 2;
			CurrentColor <= 1;
		end
		else 
		begin
			CurrentColor <= CurrentColor + 2;
		end
		
		
	end
	
endmodule