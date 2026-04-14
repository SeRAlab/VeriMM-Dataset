module top_module (
	input [3:0] m, 
	input [3:0] n, 
	input [1:0] p, 
	output reg [3:0] r);always @(*) 
		case (p)
			0: r = m << n;
			1: r = m >> n;
			2: r = m <<< n;
			3: r = m >>> n;
		endcase
	
endmodule