module power_gating_controller (
    input wire enable,
    input wire power_status,
    output wire power_gate
);

assign power_gate = enable && ~power_status;

endmodule