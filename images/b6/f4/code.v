module top_module(
		input wire [7:0] a,
		input wire en,
		output reg [7:0] y
	);always @*
		if (en)
			y = {a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7]};
		else
			y = a;
		
endmodule