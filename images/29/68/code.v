module power_gating_control (
    input wire enable,
    input wire power_state,
    input wire load,
    output wire power_gated
);
    assign power_gated = enable && power_state && ~load;
endmodule