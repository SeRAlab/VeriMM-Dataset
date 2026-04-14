module BinaryToOneHot (
    input [1:0] bin,
    output [3:0] one_hot
);
    assign one_hot = (bin == 2'b00) ? 4'b0001 :
                     (bin == 2'b01) ? 4'b0010 :
                     (bin == 2'b10) ? 4'b0100 :
                                      4'b1000;
endmodule