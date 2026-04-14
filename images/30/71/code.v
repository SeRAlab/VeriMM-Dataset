module phase_detector(
    input signal_A,
    input signal_B,
    output phase_det_out
);
    assign phase_det_out = (signal_A == signal_B) ? 1'b1 : 1'b0;
endmodule