module top_module(
	input enable,
	input clk,
	input  [1:0] wave_word,
	input  [6:0] pwm_word,
	input  [7:0] sinewave,
	input  [8:0] address,
	output reg [7:0] waveform
);always @(posedge clk) begin
	case({enable,wave_word})
		3'b100 : waveform = sinewave;                              
		3'b101 : waveform = {8{address[8]}} ^ address[7:0];        
		3'b110 : waveform = {address[8], {7{1'b1}}};               
		3'b111 : waveform = {address<{pwm_word,2'b00}, {7{1'b1}}}; 
		default : waveform = {1'b0,{7{1'b1}}};     
	endcase
end

endmodule