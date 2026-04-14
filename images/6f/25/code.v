module top_module(
    input [0:55] cd,
    output [0:47] k
    );assign	k = {cd[13], cd[16], cd[10], cd[23], cd[0], cd[4], cd[2], cd[27], cd[14], cd[5], cd[20], cd[9], cd[22], cd[18], cd[11], cd[3], cd[25], cd[7], cd[15], cd[6], cd[26], cd[19], cd[12], cd[1], cd[40], cd[51], cd[30], cd[36], cd[46], cd[54], cd[29], cd[39], cd[50], cd[44], cd[32], cd[47], cd[43], cd[48], cd[38], cd[55], cd[33], cd[52], cd[45], cd[41], cd[49], cd[35], cd[28], cd[31]};

endmodule