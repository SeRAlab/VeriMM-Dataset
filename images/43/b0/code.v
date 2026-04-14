module mux_4to1(
	input wire [7:0] i0,
	input wire [7:0] i1,
	input wire [7:0] i2,
	input wire [7:0] i3,
	input wire [1:0] sel,
	output wire [7:0] y
);assign y = (sel == 2'b00) ? i0 :
		   (sel == 2'b01) ? i1 :
		   (sel == 2'b10) ? i2 : i3;
endmodule