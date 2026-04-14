module my_module (
    out_signal,
    in_signal_1,
    in_signal_2,
    in_signal_3,
    in_signal_4,
    in_signal_5
);

    output out_signal;
    input  in_signal_1;
    input  in_signal_2;
    input  in_signal_3;
    input  in_signal_4;
    input  in_signal_5;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    assign out_signal = in_signal_1 & in_signal_2 & in_signal_3 & in_signal_4 & in_signal_5;

endmodule