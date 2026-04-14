module power_gating (
    input wire enable,
    input wire input_signal,
    output wire output_signal
);
    assign output_signal = enable ? input_signal : 1'b0;
endmodule