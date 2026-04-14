module decoder_2to4(
    input           en  ,
    input   [1:0]   in  ,

    output  [3:0]   out
);

assign out = (en) ? (1 << in) : 4'b0000;

endmodule