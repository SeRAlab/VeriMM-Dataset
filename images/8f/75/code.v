module top_module(
	input 	  [ 7:0]		SUBSEQ,			
	output     [22:0]		SUBSEQ_BUS		
);wire 			SB_02 = SUBSEQ[  7];		
wire 			SB_01 = SUBSEQ[  6];		
wire [ 3:0]	SQ    = SUBSEQ[5:2];		
wire 			STB_1	= SUBSEQ[  1];		
wire 			STB_0	= SUBSEQ[  0];		




assign SUBSEQ_BUS[22  ] = PINC; 
assign SUBSEQ_BUS[21  ] = MINC; 
assign SUBSEQ_BUS[20:0] = NSUBSQ;




wire PINC = !( SB_01 & !SB_02);	
wire MINC = !(!SB_01 &  SB_02);  




reg [19:0]  NSUBSQ;                           
wire [5:0]  subseq = {SQ[3:0], STB_1,STB_0};  

always @(subseq) begin                                 
   case(subseq)                                        
      6'b0000_00 : NSUBSQ <= 20'b11111111111111111110; 
      6'b0001_00 : NSUBSQ <= 20'b11111111111111111101; 
      6'b0010_00 : NSUBSQ <= 20'b11111111111111111011; 
      6'b0011_00 : NSUBSQ <= 20'b11111111111111110111; 
      6'b1001_00 : NSUBSQ <= 20'b11111111111111101111; 
      6'b1010_00 : NSUBSQ <= 20'b11111111111111011111; 
      6'b1011_00 : NSUBSQ <= 20'b11111111111110111111; 
      6'b1100_00 : NSUBSQ <= 20'b11111111111101111111; 
      6'b1101_00 : NSUBSQ <= 20'b11111111111011111111; 
      6'b1110_00 : NSUBSQ <= 20'b11111111110111111111; 
      6'b1111_00 : NSUBSQ <= 20'b11111111101111111111; 
      6'b0000_01 : NSUBSQ <= 20'b11111111011111111111; 
      6'b0001_01 : NSUBSQ <= 20'b11111110111111111111; 
      6'b0010_01 : NSUBSQ <= 20'b11111101111111111111; 
      6'b1001_01 : NSUBSQ <= 20'b11111011111111111111; 
      6'b1010_01 : NSUBSQ <= 20'b11110111111111111111; 
      6'b0000_10 : NSUBSQ <= 20'b11101111111111111111; 
      6'b0011_10 : NSUBSQ <= 20'b11011111111111111111; 
      6'b1010_10 : NSUBSQ <= 20'b10111111111111111111; 
      6'b1011_10 : NSUBSQ <= 20'b01111111111111111111; 
      default    : NSUBSQ <= 20'b11111111111111111111; 
   endcase 
end 


endmodule