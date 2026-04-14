module top_module(A, B, C, OUT);input  [7:0] A, B, C;
output       OUT;

wire [8:0] TMP1, TMP2, TMP3;

assign TMP1 = A - B - C;
assign TMP2 = B - A - C;
assign TMP3 = C - A - B;

assign OUT = TMP1[8] & TMP2[8] & TMP3[8];


endmodule