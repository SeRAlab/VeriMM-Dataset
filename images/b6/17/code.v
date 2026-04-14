module decoder_2to4 (
    input wire [1:0] A,
    output wire [3:0] Y
    );

assign Y[0] = ~A[1] & ~A[0];
assign Y[1] = ~A[1] &  A[0];
assign Y[2] =  A[1] & ~A[0];
assign Y[3] =  A[1] &  A[0];

endmodule