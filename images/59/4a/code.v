module top_module(
    input clk,
	 input [3:0] input_data,
    output segA, segB, segC, segD, segE, segF, segG, segDP
);reg [7:0] SevenSeg;
always @(posedge clk)
case(input_data)
    4'b0000: SevenSeg = 8'b11111100;  
    4'b0001: SevenSeg = 8'b01100000;  
    4'b0010: SevenSeg = 8'b11011010;  
    4'b0011: SevenSeg = 8'b11110010;  
    4'b0100: SevenSeg = 8'b01100110;  
    4'b0101: SevenSeg = 8'b10110110;  
    4'b0110: SevenSeg = 8'b10111110;  
    4'b0111: SevenSeg = 8'b11100000;  
    4'b1000: SevenSeg = 8'b11111110;  
    4'b1001: SevenSeg = 8'b11110110;  
	 4'b1010: SevenSeg = 8'b11101111;  
	 4'b1011: SevenSeg = 8'b11111111;  
	 4'b1100: SevenSeg = 8'b10011101;  
	 4'b1101: SevenSeg = 8'b11111101;  
	 4'b1110: SevenSeg = 8'b10011111;  
	 4'b1111: SevenSeg = 8'b10001111;  
    default: SevenSeg = 8'b00000000;  
endcase

assign {segA, segB, segC, segD, segE, segF, segG, segDP} = ~SevenSeg;
endmodule