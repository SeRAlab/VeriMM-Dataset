module power_gating (
    input wire control,
    input wire power_in,
    output wire power_out
);
    assign power_out = control ? power_in : 1'b0;
endmodule