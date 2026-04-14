module power_gating_controller(
    input wire enable,
    input wire mode,
    output wire power_on
);
    assign power_on = enable & mode;
endmodule