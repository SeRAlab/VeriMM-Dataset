module power_gating_controller(
    input wire power_on,
    input wire [7:0] load_current,
    output wire gated_power
);

assign gated_power = power_on && (load_current < 8'd10);

endmodule