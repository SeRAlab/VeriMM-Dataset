module top_module(
	VIDON,
	HC,
	VC,
	R,
	G,
	B,
	SW
);// |--------------------|
// | Port Declarations  |
// | -------------------|
input VIDON;
input [9:0] HC;
input [9:0] VC;
input [17:0] SW;
output [7:0] R;
output [7:0] G;
output [7:0] B;

// |---------------------|
// | Signal Declarations |
// | --------------------|
reg [7:0] Rr, Gg, Bb;
assign R = Rr;
assign G = Gg;
assign B = Bb;

always @ (VIDON, VC, SW)
begin
	Rr <= 8'b00000000;
	Gg <= 8'b00000000;
	Bb <= 8'b00000000;
	
	if (VIDON == 1'b1)
	begin
		if (SW != 0)
		begin
			Rr <= SW[17:10];
			Gg[1:0] <= {SW[1:0],1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
			Bb <= SW[9:2];
		end
		else
		begin
			if (VC > 400)
			begin
				Rr <= 8'b11111111;
				Gg <= 8'b00000000;
				Bb <= 8'b00000000;
			end
			else if (VC > 300)
			begin
				Rr <= 8'b00000000;
				Gg <= 8'b11110100;
				Bb <= 8'b00000000;
			end
			else if (VC > 200)
			begin
				Rr <= 8'b00000000;
				Gg <= 8'b00000000;
				Bb <= 8'b11111110;
			end
			else
			begin
				Rr <= 8'b00000000;
				Gg <= 8'b00000000;
				Bb <= 8'b00000000;
			end
		end
	end
end

endmodule