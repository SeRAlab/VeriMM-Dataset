module power_gating (
    input wire ctrl,
    output wire power_gate
);
    assign power_gate = ctrl;
endmodule