module power_gating_controller (
    input wire enable,
    input wire input_signal,
    output wire power_domain_output
);
    assign power_domain_output = enable ? input_signal : 1'b0;
endmodule