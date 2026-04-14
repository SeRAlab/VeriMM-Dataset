module top_module(
    input  data_in_0,
    input  data_in_1,
    input  ctrl,
    output data_out
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    assign data_out = (ctrl == 0) ? data_in_0 : data_in_1;

endmodule