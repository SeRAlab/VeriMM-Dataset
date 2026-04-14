module top_module(word_to_rotate, rotated_word);parameter BYTE = 8; 
	parameter WORD = 32; 
	parameter ZERO = 0; 

	input [WORD-1:ZERO] word_to_rotate;
	output [WORD-1:ZERO] rotated_word;

	assign rotated_word = { word_to_rotate[3*BYTE-1:2*BYTE] , word_to_rotate[2*BYTE-1:BYTE] , word_to_rotate[BYTE-1:ZERO], word_to_rotate[4*BYTE-1:3*BYTE] };

endmodule