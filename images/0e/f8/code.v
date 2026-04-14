module power_gating (
    input wire enable,
    input wire mode,
    output wire power_gate
);
    assign power_gate = enable ? mode : 1'b0;
endmodule