module decoder_3to8 (
    input wire [2:0] A,
    output wire [7:0] Y
    );

assign Y[0] = ~A[2] & ~A[1] & ~A[0];
assign Y[1] = ~A[2] & ~A[1] &  A[0];
assign Y[2] = ~A[2] &  A[1] & ~A[0];
assign Y[3] = ~A[2] &  A[1] &  A[0];
assign Y[4] =  A[2] & ~A[1] & ~A[0];
assign Y[5] =  A[2] & ~A[1] &  A[0];
assign Y[6] =  A[2] &  A[1] & ~A[0];
assign Y[7] =  A[2] &  A[1] &  A[0];

endmodule