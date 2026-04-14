module top_module(
    input [0:31] S,
    output [31:0] P_S
	 
    );assign P_S = {S[15], S[6], S[19], S[20], S[28], S[11], S[27], S[16], S[0], S[14], S[22], S[25], S[4], S[17], S[30], S[9], S[1], S[7], S[23], S[13], S[31], S[26], S[2], S[8], S[18], S[12], S[29], S[5], S[21], S[10], S[3], S[24]};
endmodule