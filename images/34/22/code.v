module power_gating (
    input wire power_en,
    input wire power_gnd,
    output wire device_state
);
    assign device_state = power_en && ~power_gnd;
endmodule