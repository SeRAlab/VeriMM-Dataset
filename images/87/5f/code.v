module top_module(
   input [15:0] a,
   input [15:0] b,
   input [3:0] op,
   output reg [15:0] r,
   output reg zero,
   output reg ovfl
   );always @(*) begin
		ovfl = 0;
		case (op)
			4'b0001: begin
				
				
				
				
				
				
				
				
				
				
				
				r = b + a;			   
				if (a[15] == b[15] && r[15] != a[15]) ovfl = 1;
			end
			4'b0010: begin
				
				
				
				
				
				
				
				
				
				
				
				r = b - a;				
				if (a[15] == 0 && b[15] == 1 && r[15] == 1) ovfl = 1;
				if (a[15] == 1 && b[15] == 0 && r[15] == 0) ovfl = 1;
			end
			4'b0011: r = (a && b);	
			4'b0100: r = (a || b);	
			4'b0101: r = ($signed(b) < $signed(a));	
			4'b0110: r = (a & b);	
			4'b0111: r = (a | b); 	
			4'b1000: r = ~(a | b);	
			4'b1001: r = (a ^ b);	
			4'b1010: r = (a << b);	
			4'b1011: r = (a >> b);	
			4'b1100: r = ($signed(a) >>> b);	
		endcase
		zero = (r == 0);
	end
	
endmodule