module top_module(I0,I1,I2,I3,I4,I5,I6,I7,A,B,C,D,E,F,G);input wire I0 ;
	input wire I1 ;
	input wire I2 ;
	input wire I3 ;
	input wire I4 ;
	input wire I5 ;
	input wire I6 ;
	input wire I7 ;
	
	output wire A ;
	output wire B ;
	output wire C ;
	output wire D ;
	output wire E ;
	output wire F ;
	output wire G ;
	
	reg [6:0] SEG7;
	
	always @ (I7,I6,I5,I4,I3,I2,I1,I0) begin
		casez ({I7,I6,I5,I4,I3,I2,I1,I0})
		  8'b00000000: SEG7 = 7'b0111110;
		  8'b00000001: SEG7 = 7'b1110111;
		  8'b0000001?: SEG7 = 7'b0110000;
		  8'b000001??: SEG7 = 7'b1101101;
		  8'b00001???: SEG7 = 7'b1111001;
		  8'b0001????: SEG7 = 7'b0110011;
		  8'b001?????: SEG7 = 7'b1011011;
		  8'b01??????: SEG7 = 7'b1011111;
		  8'b1???????: SEG7 = 7'b1110000;
		endcase
	end
	
	assign{A,B,C,D,E,F,G} = ~SEG7;endmodule