module top_module(
    //# {{data|Data Signals}}
    input  [1:0] A   ,
    input  [1:0] B   ,
    output EQ  ,
    output GT  ,

    //# {{power|Power}}
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);wire [1:0] diff = A - B;

    assign EQ = ~|diff;
    assign GT = diff[1] ? A[1] : diff[0] ? A[0] : 0;

endmodule