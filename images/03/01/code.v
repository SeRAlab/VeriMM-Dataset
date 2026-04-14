module decoder_2to4 (
    input wire [1:0] A,
    output wire [3:0] Y
);
    assign Y = (A == 2'd0) ? 4'b0001 :
               (A == 2'd1) ? 4'b0010 :
               (A == 2'd2) ? 4'b0100 :
               (A == 2'd3) ? 4'b1000 : 4'b0000;
endmodule