module top_module(
    input [31:0] in1,
    input [31:0] in2,
    output [32:0] res
);wire [7:0] temp [0:24];
genvar i; // Declare genvar variable

generate
    for(i=0; i<25; i=i+1) begin : adder
        assign temp[i] = in1[i*8 +: 8] + in2[i*8 +: 8];
    end
endgenerate

assign res[32:0] = {temp[24][7:0], temp[23][7:0], temp[22][7:0], temp[21][7:0], temp[20][7:0], 
                    temp[19][7:0], temp[18][7:0], temp[17][7:0], temp[16][7:0], 
                    temp[15][7:0], temp[14][7:0], temp[13][7:0], temp[12][7:0], 
                    temp[11][7:0], temp[10][7:0], temp[9][7:0], temp[8][7:0], 
                    temp[7][7:0], temp[6][7:0], temp[5][7:0], temp[4][7:0], 
                    temp[3][7:0], temp[2][7:0], temp[1][7:0], temp[0][7:0]};

endmodule