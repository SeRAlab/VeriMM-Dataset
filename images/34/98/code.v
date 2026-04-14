module power_gating_control (
    input wire enable,
    input wire power_gating,
    output wire out
);
    assign out = (power_gating == 0) ? enable : 0;
endmodule