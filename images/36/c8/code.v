module power_gating(
    input wire enable,
    input wire power_state,
    output wire gated_power
);
    assign gated_power = enable & power_state;
endmodule