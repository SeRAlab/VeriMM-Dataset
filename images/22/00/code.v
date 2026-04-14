module power_gating_controller (
    input wire enable,
    input wire module1_status,
    input wire module2_status,
    output wire module1_power,
    output wire module2_power
);

assign module1_power = enable ? module1_status : 0;
assign module2_power = enable ? module2_status : 0;

endmodule