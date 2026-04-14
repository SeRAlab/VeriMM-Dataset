module top_module(input            clock, clear,
					 input 	   [3:0] data0, data1, data2, data3,				
					 output 			   decimal,
					 output reg [3:0] enable,
					 output reg [6:0] segs);reg [19:0] ticks = 0; 
	reg [3:0]  digit = 0; 
	
	assign decimal = 1; 

	always@(posedge clock)
		if(clear)
			ticks <= 0;
		else if (ticks > 800000) 
			ticks <= 0;
		else
			ticks <= ticks + 1;

	always@(*)
	begin
		digit = 4'h0;
		enable = 4'hF; 
		
		if(ticks < 200000) 
		begin
			digit = data0; 
			enable[0] = 0;
		end
		else if((ticks > 200000) && (ticks < 400000)) 
		begin
			digit = data1; 
			enable[1] = 0;
		end
		else if((ticks > 400000) && (ticks < 600000)) 
		begin
			digit = data2; 
			enable[2] = 0;
		end
		else if((ticks > 600000) && (ticks < 800000)) 
		begin
			digit = data3; 
			enable[3] = 0;
		end
	end
	
	always@(*) 
		case(digit) 
			0:  segs = 7'b1000000; 
			1:  segs = 7'b1111001; 
			2:  segs = 7'b0100100; 
			3:  segs = 7'b0110000; 
			4:  segs = 7'b0011001; 
			5:  segs = 7'b0010010; 
			6:  segs = 7'b0000010; 
			7:  segs = 7'b1111000; 
			8:  segs = 7'b0000000; 
			9:  segs = 7'b0010000; 
			10: segs = 7'b0001000; 
			11: segs = 7'b0000011; 
			12: segs = 7'b1000110; 
			13: segs = 7'b0100001; 
			14: segs = 7'b0000110; 
			15: segs = 7'b0001110; 
			default: segs = 7'b0110110; 
		endcase
		
endmodule