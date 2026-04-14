module CLK_DIV2_Wrapper (
input    Reset,
input    IN,
output   OUT
);
reg clki;
	always@(posedge IN or posedge Reset)
	begin
		if(Reset)
			clki <= 0;
		else 
			clki <= ~clki;
	end
	assign OUT = clki;
endmodule