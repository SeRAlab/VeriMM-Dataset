module top_module(
    input  SLEEP  ,
    output VIRTPWR
);// Voltage supply signals
    supply1 VPWR;
    supply1 VPB ;
    supply0 VNB ;

    assign VPWR = SLEEP ? 1'b0 : 1'b1;
    assign VPB = SLEEP ? 1'b0 : 1'b1;
    assign VNB = 1'b0;
    assign VIRTPWR = SLEEP ? 1'b0 : 1'b1;

endmodule